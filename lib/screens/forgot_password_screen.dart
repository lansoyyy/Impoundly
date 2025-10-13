import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';
import 'package:vehicle_impound_app/widgets/textfield_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset,
                        size: 80,
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextWidget(
                    text: 'Forgot Password?',
                    fontSize: 28,
                    color: primary,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(height: 10),
                  TextWidget(
                    text:
                        'Don\'t worry! Enter your email address and we\'ll send you a link to reset your password.',
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 40),
                  TextFieldWidget(
                    label: 'Email Address',
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
                  const SizedBox(height: 40),
                  Center(
                    child: ButtonWidget(
                      label: 'Send Reset Link',
                      onPressed: _isLoading ? null : _handleResetPassword,
                      width: double.infinity,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, color: primary, size: 20),
                          const SizedBox(width: 8),
                          TextWidget(
                            text: 'Back to Login',
                            fontSize: 16,
                            color: primary,
                            fontFamily: 'Bold',
                          ),
                        ],
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

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await FirebaseService.sendPasswordResetEmail(
        _emailController.text.trim(),
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
                  Icon(Icons.mark_email_read, color: Colors.green, size: 60),
                  const SizedBox(height: 15),
                  TextWidget(
                    text: 'Email Sent!',
                    fontSize: 22,
                    color: Colors.green,
                    fontFamily: 'Bold',
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    text: result['message'],
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                    align: TextAlign.center,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextWidget(
                            text:
                                'Check your spam folder if you don\'t see the email.',
                            fontSize: 12,
                            color: Colors.blue,
                            fontFamily: 'Regular',
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}
