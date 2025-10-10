import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vehicle_impound_app/screens/register_screen.dart';
import 'package:vehicle_impound_app/screens/role_selection_screen.dart';
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
                        // TODO: Implement forgot password
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Implement login logic
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoleSelectionScreen(),
                            ),
                          );
                        }
                      },
                      width: double.infinity,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
