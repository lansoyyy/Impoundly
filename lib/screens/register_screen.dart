import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';
import 'package:vehicle_impound_app/widgets/textfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'Driver';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Create Account',
                    fontSize: 28,
                    color: primary,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    text: 'Register to get started',
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                  ),
                  const SizedBox(height: 30),
                  // Role Selection
                  TextWidget(
                    text: 'Select Role',
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildRoleCard('Driver', Icons.person),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildRoleCard('Enforcer', Icons.badge),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextFieldWidget(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _nameController,
                    borderColor: primary,
                    prefix: const Icon(Icons.person_outline, color: primary),
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 15),
                  TextFieldWidget(
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    controller: _phoneController,
                    inputType: TextInputType.phone,
                    borderColor: primary,
                    prefix: const Icon(Icons.phone_outlined, color: primary),
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 15),
                  TextFieldWidget(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    isObscure: true,
                    showEye: true,
                    borderColor: primary,
                    prefix: const Icon(Icons.lock_outline, color: primary),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ButtonWidget(
                      label: 'Register',
                      onPressed: _isLoading ? null : _handleRegister,
                      width: double.infinity,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: 'Already have an account? ',
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Regular',
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: TextWidget(
                          text: 'Login',
                          fontSize: 14,
                          color: primary,
                          fontFamily: 'Bold',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String role, IconData icon) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? primary.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : primary,
              size: 40,
            ),
            const SizedBox(height: 10),
            TextWidget(
              text: role,
              fontSize: 16,
              color: isSelected ? Colors.white : primary,
              fontFamily: 'Bold',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await FirebaseService.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 15),
                  TextWidget(
                    text: 'Registration Successful!',
                    fontSize: 20,
                    color: Colors.green,
                    fontFamily: 'Bold',
                  ),
                ],
              ),
              content: TextWidget(
                text: result['message'],
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Regular',
                align: TextAlign.center,
                maxLines: 5,
              ),
              actions: [
                Center(
                  child: ButtonWidget(
                    label: 'OK',
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back to login
                    },
                    width: 150,
                  ),
                ),
              ],
            ),
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
