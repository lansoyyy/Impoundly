import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vehicle_impound_app/screens/admin/admin_dashboard_screen.dart';
import 'package:vehicle_impound_app/screens/driver/driver_dashboard_screen.dart';
import 'package:vehicle_impound_app/screens/enforcer/enforcer_dashboard_screen.dart';
import 'package:vehicle_impound_app/screens/forgot_password_screen.dart';
import 'package:vehicle_impound_app/screens/register_screen.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';
import 'package:vehicle_impound_app/widgets/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          FontAwesomeIcons.car,
                          size: 50,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextWidget(
                    text: 'Welcome Back!',
                    fontSize: 28,
                    color: primary,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    text: 'Login to your account',
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                  ),
                  const SizedBox(height: 40),
                  TextFieldWidget(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                    borderColor: primary,
                    prefix: const Icon(Icons.email_outlined, color: primary),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFieldWidget(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    isObscure: true,
                    showEye: true,
                    borderColor: primary,
                    prefix: const Icon(Icons.lock_outline, color: primary),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: TextWidget(
                        text: 'Forgot Password?',
                        fontSize: 14,
                        color: primary,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ButtonWidget(
                      label: 'Login',
                      onPressed: _isLoading ? null : _handleLogin,
                      width: double.infinity,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: "Don't have an account? ",
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Regular',
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: TextWidget(
                          text: 'Register',
                          fontSize: 14,
                          color: primary,
                          fontFamily: 'Bold',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextWidget(
                          text: 'OR',
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Medium',
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Admin Login Button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showAdminLoginDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.purple.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.admin_panel_settings,
                                color: Colors.purple, size: 24),
                            const SizedBox(width: 10),
                            TextWidget(
                              text: 'Continue as Admin',
                              fontSize: 16,
                              color: Colors.purple,
                              fontFamily: 'Bold',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAdminLoginDialog() {
    final adminUsernameController = TextEditingController();
    final adminPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.admin_panel_settings,
                  color: Colors.purple, size: 40),
            ),
            const SizedBox(height: 15),
            TextWidget(
              text: 'Admin Login',
              fontSize: 22,
              color: Colors.purple,
              fontFamily: 'Bold',
            ),
            const SizedBox(height: 5),
            TextWidget(
              text: 'Enter admin credentials',
              fontSize: 13,
              color: Colors.grey[600],
              fontFamily: 'Regular',
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFieldWidget(
                label: 'Username',
                hint: 'Enter admin username',
                controller: adminUsernameController,
                borderColor: Colors.purple,
                height: 60,
                prefix: Icon(Icons.person, color: Colors.purple),
              ),
              const SizedBox(height: 15),
              TextFieldWidget(
                label: 'Password',
                hint: 'Enter admin password',
                controller: adminPasswordController,
                borderColor: Colors.purple,
                height: 60,
                isObscure: true,
                showEye: true,
                prefix: Icon(Icons.lock, color: Colors.purple),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextWidget(
                        text: 'Default: admin / admin123',
                        fontSize: 11,
                        color: Colors.orange,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: TextWidget(
              text: 'Cancel',
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Medium',
            ),
          ),
          ButtonWidget(
            label: 'Login',
            onPressed: () {
              // Hardcoded admin credentials
              if (adminUsernameController.text == 'admin' &&
                  adminPasswordController.text == 'admin123') {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboardScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid admin credentials!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            color: Colors.purple,
            width: 120,
            height: 45,
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await FirebaseService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        final userData = result['userData'] as Map<String, dynamic>;
        final role = userData['role'];

        if (mounted) {
          // Navigate based on role
          Widget destination;
          if (role == 'Driver') {
            destination = const DriverDashboardScreen();
          } else if (role == 'Enforcer') {
            destination = const EnforcerDashboardScreen();
          } else {
            destination = const DriverDashboardScreen();
          }

          // Use pushAndRemoveUntil to clear the navigation stack
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => destination),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
