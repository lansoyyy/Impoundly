# Auto-Login Feature Guide - Impoundly App

## Overview
The auto-login feature automatically logs in users who have previously signed in, providing a seamless experience without requiring them to enter credentials every time they open the app.

## How It Works

### 1. **Splash Screen Check**
When the app starts, the splash screen performs the following checks:

```
App Launch
    ↓
Splash Screen (3 seconds)
    ↓
Check Firebase Auth
    ↓
Is User Logged In?
    ├── NO → Navigate to Landing Screen
    └── YES → Fetch User Data from Firestore
                ↓
            Check Account Status
                ├── Status: 'active' → Navigate to Role Dashboard
                │   ├── Driver → Driver Dashboard
                │   └── Enforcer → Enforcer Dashboard
                └── Status: 'pending/suspended/rejected' → Logout & Landing Screen
```

### 2. **Implementation Details**

#### Splash Screen (`splash_screen.dart`)
- Waits 3 seconds for animations
- Calls `_checkAutoLogin()` method
- Checks `FirebaseService.getCurrentUser()`
- If user exists, fetches user data from Firestore
- Validates account status
- Navigates to appropriate screen

#### Key Checks:
1. **User Authentication**: Is there a Firebase Auth user?
2. **Account Status**: Is the account status 'active'?
3. **Role-Based Navigation**: Navigate based on user role

### 3. **Account Status Handling**

| Status | Action |
|--------|--------|
| `active` | Auto-login successful, navigate to dashboard |
| `pending` | Logout user, go to landing screen |
| `suspended` | Logout user, go to landing screen |
| `rejected` | Logout user, go to landing screen |
| No user data | Go to landing screen |

### 4. **Logout Functionality**

Both Driver and Enforcer dashboards now have logout buttons:

#### Features:
- Logout icon in the top-right corner
- Confirmation dialog before logout
- Calls `FirebaseService.logoutUser()`
- Clears Firebase Auth session
- Navigates to Landing Screen using `pushAndRemoveUntil` (clears navigation stack)

## User Flow Examples

### Scenario 1: First Time User
1. Opens app → Splash Screen
2. No user logged in → Landing Screen
3. User registers/logs in
4. Navigates to dashboard

### Scenario 2: Returning Active User
1. Opens app → Splash Screen
2. User is logged in → Fetches user data
3. Status is 'active' → Directly to Dashboard
4. **No login required!**

### Scenario 3: Suspended User
1. Opens app → Splash Screen
2. User is logged in → Fetches user data
3. Status is 'suspended' → Logout
4. Landing Screen (must login again, will see error)

### Scenario 4: User Logs Out
1. User clicks logout icon
2. Confirmation dialog appears
3. User confirms → Firebase logout
4. Landing Screen
5. Next app launch → No auto-login

## Code Implementation

### Splash Screen Auto-Login Check
```dart
Future<void> _checkAutoLogin() async {
  try {
    final currentUser = FirebaseService.getCurrentUser();
    
    if (currentUser != null) {
      final userData = await FirebaseService.getUserData(currentUser.uid);
      
      if (userData != null && userData['status'] == 'active') {
        // Navigate to appropriate dashboard
        Widget destination;
        if (userData['role'] == 'Driver') {
          destination = const DriverDashboardScreen();
        } else if (userData['role'] == 'Enforcer') {
          destination = const EnforcerDashboardScreen();
        }
        
        Navigator.pushReplacement(context, ...);
        return;
      } else {
        await FirebaseService.logoutUser();
      }
    }
    
    // Go to landing screen
    Navigator.pushReplacement(context, LandingScreen());
  } catch (e) {
    // Error handling
  }
}
```

### Logout Implementation
```dart
void _showLogoutDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Logout'),
      content: Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseService.logoutUser();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LandingScreen()),
              (route) => false,
            );
          },
          child: Text('Logout'),
        ),
      ],
    ),
  );
}
```

## Security Considerations

1. **Session Persistence**: Firebase Auth maintains session across app restarts
2. **Token Expiration**: Firebase automatically handles token refresh
3. **Status Validation**: Always checks account status before allowing access
4. **Forced Logout**: Suspended/pending accounts are automatically logged out

## Benefits

✅ **Better UX**: Users don't need to login every time  
✅ **Faster Access**: Direct navigation to dashboard  
✅ **Security**: Status checks prevent unauthorized access  
✅ **Clean Navigation**: Proper stack management with logout  

## Testing

### Test Auto-Login
1. Login as a driver/enforcer
2. Close the app completely
3. Reopen the app
4. Should automatically navigate to dashboard

### Test Logout
1. Click logout icon
2. Confirm logout
3. Should navigate to landing screen
4. Reopen app → Should go to landing screen (no auto-login)

### Test Suspended Account
1. Admin suspends a user account
2. User reopens app
3. Should be logged out automatically
4. Landing screen shown

## Future Enhancements

- [ ] Add biometric authentication (fingerprint/face ID)
- [ ] Add "Remember Me" toggle option
- [ ] Add session timeout after X days of inactivity
- [ ] Add device management (logout from all devices)
- [ ] Add login history tracking
