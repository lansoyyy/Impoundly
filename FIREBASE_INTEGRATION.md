# Firebase Integration Guide - Impoundly App

## Overview
This document explains the Firebase Authentication and Firestore integration implemented in the Impoundly app.

## Features Implemented

### 1. **Firebase Authentication**
- User registration with email and password
- User login with email and password
- Role-based authentication (Driver, Enforcer)
- Account status management (pending, active, suspended, rejected)

### 2. **Firestore Database Structure**

#### Users Collection (`users`)
```
users/
  └── {userId}/
      ├── uid: string
      ├── name: string
      ├── email: string
      ├── phone: string
      ├── role: string (Driver | Enforcer)
      ├── status: string (pending | active | suspended | rejected)
      ├── createdAt: timestamp
      ├── approvedAt: timestamp (optional)
      ├── rejectedAt: timestamp (optional)
      └── rejectionReason: string (optional)
```

#### Vehicles Collection (`vehicles`)
```
vehicles/
  └── {vehicleId}/
      ├── userId: string
      ├── plateNumber: string
      ├── vehicleMake: string
      ├── vehicleModel: string
      ├── vehicleColor: string
      ├── orNumber: string
      ├── crNumber: string
      ├── status: string
      └── createdAt: timestamp
```

## How It Works

### Registration Flow
1. User fills registration form with name, email, phone, password, and selects role
2. `FirebaseService.registerUser()` is called
3. User account is created in Firebase Auth
4. User data is stored in Firestore `users` collection
5. **Driver accounts** are set to `status: 'pending'` (requires admin approval)
6. **Enforcer accounts** are set to `status: 'active'` (pre-approved)
7. Success message is shown and user is redirected to login

### Login Flow
1. User enters email and password
2. `FirebaseService.loginUser()` is called
3. Firebase Auth authenticates the user
4. User data is fetched from Firestore
5. **Status checks**:
   - If `status: 'pending'` → Login denied, message: "Your account is pending admin approval"
   - If `status: 'suspended'` → Login denied, message: "Your account has been suspended"
   - If `status: 'rejected'` → Login denied (can be handled)
   - If `status: 'active'` → Login successful
6. User is navigated to appropriate dashboard based on role:
   - **Driver** → `DriverDashboardScreen`
   - **Enforcer** → `EnforcerDashboardScreen`

### Admin Features
- View pending driver verifications
- Approve driver accounts (changes status to 'active')
- Reject driver accounts with reason (changes status to 'rejected')
- Manage users (add, edit, suspend, delete)

## Firebase Service Methods

### Authentication
- `registerUser()` - Create new user account
- `loginUser()` - Authenticate user
- `logoutUser()` - Sign out current user
- `getCurrentUser()` - Get current authenticated user

### User Management
- `getUserData(uid)` - Fetch user data from Firestore
- `updateUserData(uid, data)` - Update user information
- `getUsersByRole(role)` - Get all users by role (Driver/Enforcer)

### Driver Verification (Admin)
- `getPendingVerifications()` - Get all pending driver registrations
- `approveDriver(userId)` - Approve driver account
- `rejectDriver(userId, reason)` - Reject driver account

### Vehicle Management
- `registerVehicle()` - Register a vehicle for driver
- `getUserVehicles(userId)` - Get all vehicles for a user

## Security Rules (Recommended)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth.uid == userId || 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'Admin';
      allow delete: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'Admin';
    }
    
    // Vehicles collection
    match /vehicles/{vehicleId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'Driver';
      allow update: if request.auth != null && 
                      resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && 
                      resource.data.userId == request.auth.uid;
    }
  }
}
```

## Admin Credentials
- **Username**: `admin`
- **Password**: `admin123`
- Admin login is hardcoded and does not use Firebase Auth

## Testing

### Test Driver Registration
1. Go to Register screen
2. Select "Driver" role
3. Fill in all fields
4. Click Register
5. Account will be created with `status: 'pending'`
6. Try to login → Should show "Your account is pending admin approval"

### Test Admin Approval
1. Login as admin (username: admin, password: admin123)
2. Go to "Pending Verifications"
3. Approve the driver account
4. Driver can now login successfully

### Test Enforcer Registration
1. Register as "Enforcer"
2. Account is created with `status: 'active'`
3. Can login immediately without admin approval

## Error Handling
- Email already in use
- Weak password (< 6 characters)
- Invalid email format
- Wrong password
- User not found
- Account pending approval
- Account suspended
- Network errors

## Next Steps
1. Implement password reset functionality
2. Add email verification
3. Implement real-time notifications using Firebase Cloud Messaging
4. Add profile picture upload using Firebase Storage
5. Implement vehicle document upload (OR/CR, License)
