import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vehicle_impound_app/screens/landing_screen.dart';
import 'package:vehicle_impound_app/screens/driver/driver_dashboard_screen.dart';
import 'package:vehicle_impound_app/screens/enforcer/enforcer_dashboard_screen.dart';
import 'package:vehicle_impound_app/screens/splash_screen.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Wait a moment for Firebase to initialize
    await Future.delayed(const Duration(milliseconds: 500));

    // Get current user
    final currentUser = FirebaseAuth.instance.currentUser;

    if (kDebugMode) {
      print('AuthWrapper: Current user is ${currentUser?.email ?? 'null'}');
    }

    setState(() {
      _user = currentUser;
      _isLoading = true;
    });

    if (currentUser != null) {
      // User is authenticated, fetch user data
      final userData = await FirebaseService.getUserData(currentUser.uid);
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    } else {
      // User is not authenticated
      setState(() {
        _userData = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show splash screen while checking auth state
      return const SplashScreen();
    }

    if (_user == null) {
      // User is not authenticated, show landing screen
      if (kDebugMode) {
        print('AuthWrapper: No user, showing landing screen');
      }
      return const LandingScreen();
    }

    if (_userData == null) {
      // User is authenticated but no data found, show landing screen
      if (kDebugMode) {
        print(
            'AuthWrapper: User authenticated but no data found, showing landing screen');
      }
      return const LandingScreen();
    }

    // Check account status
    final status = _userData!['status'];
    if (status != 'active') {
      // Account is not active, logout and show landing screen
      if (kDebugMode) {
        print('AuthWrapper: Account not active (status: $status), logging out');
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await FirebaseService.logoutUser();
      });
      return const LandingScreen();
    }

    // User is authenticated and account is active
    final role = _userData!['role'];

    if (kDebugMode) {
      print(
          'AuthWrapper: User authenticated with role: $role, navigating to dashboard');
    }

    if (role == 'Driver') {
      return const DriverDashboardScreen();
    } else if (role == 'Enforcer') {
      return const EnforcerDashboardScreen();
    } else {
      // Unknown role, show landing screen
      if (kDebugMode) {
        print('AuthWrapper: Unknown role, showing landing screen');
      }
      return const LandingScreen();
    }
  }
}
