# Forgot Password Feature Guide - Impoundly App

## Overview
The forgot password feature allows users to reset their password by receiving a password reset link via email using Firebase Authentication.

## How It Works

### User Flow
```
Login Screen
    ↓
Click "Forgot Password?"
    ↓
Forgot Password Screen
    ↓
Enter Email Address
    ↓
Click "Send Reset Link"
    ↓
Firebase sends password reset email
    ↓
User receives email with reset link
    ↓
User clicks link in email
    ↓
Firebase hosted password reset page
    ↓
User enters new password
    ↓
Password updated successfully
    ↓
User can login with new password
```

## Implementation Details

### 1. **Firebase Service Method**

Added `sendPasswordResetEmail()` method in `firebase_service.dart`:

```dart
static Future<Map<String, dynamic>> sendPasswordResetEmail(String email) async {
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
  }
}
```

### 2. **Forgot Password Screen**

Created `forgot_password_screen.dart` with:
- Email input field with validation
- Send reset link button with loading state
- Success dialog with instructions
- Back to login navigation
- Error handling with user-friendly messages

### 3. **Login Screen Integration**

Updated login screen:
- "Forgot Password?" button navigates to forgot password screen
- Maintains existing login functionality

## Features

### ✅ **Email Validation**
- Checks if email is not empty
- Validates email format (contains @)
- Firebase validates if email exists in system

### ✅ **User Feedback**
- Loading indicator while processing
- Success dialog with confirmation
- Error messages for various scenarios
- Reminder to check spam folder

### ✅ **Error Handling**
| Error Code | User Message |
|------------|--------------|
| `user-not-found` | No user found with this email address |
| `invalid-email` | The email address is not valid |
| Network error | An error occurred: [error details] |

### ✅ **Security**
- Uses Firebase's secure password reset mechanism
- Reset link expires after 1 hour (Firebase default)
- One-time use link
- No password exposed in email

## UI/UX Features

### Design Elements
- Lock reset icon at the top
- Clear instructions for users
- Email input with validation
- Loading state during processing
- Success dialog with helpful tips
- Back to login button

### User Messages
- **Success**: "Password reset email sent! Please check your inbox."
- **Tip**: "Check your spam folder if you don't see the email."
- **Error**: Context-specific error messages

## Testing

### Test Successful Reset
1. Go to login screen
2. Click "Forgot Password?"
3. Enter valid registered email
4. Click "Send Reset Link"
5. Check email inbox (and spam folder)
6. Click reset link in email
7. Enter new password on Firebase page
8. Return to app and login with new password

### Test Error Cases

#### Non-existent Email
1. Enter email not registered in system
2. Click "Send Reset Link"
3. Should show: "No user found with this email address"

#### Invalid Email Format
1. Enter invalid email (e.g., "test" without @)
2. Form validation should prevent submission
3. Shows: "Please enter a valid email"

#### Empty Email
1. Leave email field empty
2. Click "Send Reset Link"
3. Shows: "Please enter your email"

## Firebase Configuration

### Email Template Customization
You can customize the password reset email in Firebase Console:

1. Go to Firebase Console
2. Select your project
3. Go to Authentication → Templates
4. Select "Password reset"
5. Customize:
   - Email subject
   - Email body
   - Sender name
   - Reply-to email

### Default Firebase Reset Email
Firebase sends a default email with:
- Subject: "Reset your password for [App Name]"
- Reset link that expires in 1 hour
- Instructions to reset password
- Link to Firebase hosted reset page

## Code Examples

### Calling Reset Password
```dart
final result = await FirebaseService.sendPasswordResetEmail(
  _emailController.text.trim(),
);

if (result['success']) {
  // Show success dialog
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Email Sent!'),
      content: Text(result['message']),
    ),
  );
} else {
  // Show error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(result['message'])),
  );
}
```

### Navigation from Login
```dart
TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  },
  child: Text('Forgot Password?'),
)
```

## User Instructions

### For Users Who Forgot Password:

1. **On Login Screen**
   - Click "Forgot Password?" link

2. **Enter Email**
   - Type the email address you used to register
   - Make sure it's spelled correctly

3. **Check Email**
   - Look for email from Firebase/Impoundly
   - Check spam/junk folder if not in inbox
   - Email usually arrives within 1-2 minutes

4. **Click Reset Link**
   - Open the email
   - Click the "Reset Password" button/link
   - Link expires in 1 hour

5. **Set New Password**
   - You'll be taken to a secure page
   - Enter your new password
   - Confirm the new password
   - Click "Save"

6. **Login**
   - Return to the app
   - Login with your email and new password

## Security Best Practices

✅ **Link Expiration**: Reset links expire after 1 hour  
✅ **One-time Use**: Each link can only be used once  
✅ **Secure Transmission**: Links sent via secure email  
✅ **No Password Exposure**: Password never sent in email  
✅ **Firebase Hosted**: Reset page hosted on secure Firebase domain  

## Troubleshooting

### Email Not Received
- Check spam/junk folder
- Verify email address is correct
- Wait a few minutes (can take up to 5 minutes)
- Check if email exists in system
- Try resending the reset email

### Link Expired
- Request a new reset link
- Links expire after 1 hour
- Each request generates a new link

### Link Already Used
- Each link can only be used once
- Request a new reset link if needed

## Future Enhancements

- [ ] Add rate limiting (prevent spam)
- [ ] Add custom email templates
- [ ] Add in-app password reset (without email)
- [ ] Add password strength indicator
- [ ] Add "Resend Email" button
- [ ] Add email verification before reset
- [ ] Add SMS-based password reset option
- [ ] Add security questions as alternative

## Related Features

- **Login**: Users can login after resetting password
- **Register**: New users create account with password
- **Auto-Login**: After reset, users must login manually
- **Account Status**: Reset works for active, pending, and suspended accounts

## Notes

- Password reset works for all user roles (Driver, Enforcer)
- Admin accounts use hardcoded credentials (no reset needed)
- Reset email is sent even if account is pending/suspended
- Users must still have active status to login after reset
