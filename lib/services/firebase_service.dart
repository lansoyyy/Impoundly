import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Register user with email and password
  static Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'status': role == 'Driver' ? 'pending' : 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': role == 'Driver'
            ? 'Registration successful! Please wait for admin approval.'
            : 'Registration successful!',
        'uid': userCredential.user!.uid,
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        print('Attempting to login user: $email');
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print('Login successful for user: ${userCredential.user?.uid}');
      }

      // Get user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        if (kDebugMode) {
          print('User data not found in Firestore');
        }
        await _auth.signOut();
        return {'success': false, 'message': 'User data not found'};
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Check if user is active
      if (userData['status'] == 'pending') {
        if (kDebugMode) {
          print('User account is pending approval');
        }
        await _auth.signOut();
        return {
          'success': false,
          'message': 'Your account is pending admin approval'
        };
      }

      if (userData['status'] == 'suspended') {
        if (kDebugMode) {
          print('User account is suspended');
        }
        await _auth.signOut();
        return {'success': false, 'message': 'Your account has been suspended'};
      }

      if (kDebugMode) {
        print('User account is active, login complete');
      }

      return {
        'success': true,
        'message': 'Login successful',
        'userData': userData,
      };
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth exception: ${e.code} - ${e.message}');
      }
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        message = 'This user account has been disabled.';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  // Logout user
  static Future<void> logoutUser() async {
    if (kDebugMode) {
      print('Logging out user');
    }
    await _auth.signOut();
    if (kDebugMode) {
      print('User logged out successfully');
    }
  }

  // Send password reset email
  static Future<Map<String, dynamic>> sendPasswordResetEmail(
      String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent! Please check your inbox.'
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to send reset email';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email address.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      if (kDebugMode) {
        print('Fetching user data for UID: $uid');
      }
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        if (kDebugMode) {
          print('User data found for UID: $uid');
        }
        return userDoc.data() as Map<String, dynamic>;
      }
      if (kDebugMode) {
        print('User data not found for UID: $uid');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      return null;
    }
  }

  // Update user data
  static Future<bool> updateUserData(
      String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if email exists (deprecated method removed)
  static Future<bool> checkEmailExists(String email) async {
    try {
      // Try to create a temporary sign-in to check if email exists
      // This is a workaround since fetchSignInMethodsForEmail is deprecated
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: 'temporary_password_check',
      );
      return false; // Email doesn't exist
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true; // Email exists
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Register vehicle for driver
  static Future<Map<String, dynamic>> registerVehicle({
    required String userId,
    required String plateNumber,
    required String vehicleMake,
    required String vehicleModel,
    required String vehicleColor,
    required String orNumber,
    required String crNumber,
  }) async {
    try {
      await _firestore.collection('vehicles').add({
        'userId': userId,
        'plateNumber': plateNumber.toUpperCase(),
        'vehicleMake': vehicleMake,
        'vehicleModel': vehicleModel,
        'vehicleColor': vehicleColor,
        'orNumber': orNumber,
        'crNumber': crNumber,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'Vehicle registered successfully'};
    } catch (e) {
      return {'success': false, 'message': 'Failed to register vehicle: $e'};
    }
  }

  // Get user vehicles
  static Future<List<Map<String, dynamic>>> getUserVehicles(
      String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('vehicles')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Delete vehicle
  static Future<bool> deleteVehicle(String vehicleId) async {
    try {
      await _firestore.collection('vehicles').doc(vehicleId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update vehicle
  static Future<bool> updateVehicle(
      String vehicleId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('vehicles').doc(vehicleId).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get pending verifications (for admin)
  static Future<List<Map<String, dynamic>>> getPendingVerifications() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Driver')
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Approve driver
  static Future<bool> approveDriver(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'status': 'active',
        'approvedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Reject driver
  static Future<bool> rejectDriver(String userId, String reason) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'status': 'rejected',
        'rejectionReason': reason,
        'rejectedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get all users by role
  static Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      return [];
    }
  }
}
