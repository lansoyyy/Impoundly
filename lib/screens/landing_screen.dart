import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vehicle_impound_app/screens/login_screen.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primary,
              primary.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    FontAwesomeIcons.car,
                    size: 120,
                    color: primary,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextWidget(
                text: 'IMPOUNDLY',
                fontSize: 36,
                color: Colors.white,
                fontFamily: 'Bold',
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextWidget(
                  text:
                      'Real-Time Vehicle Impound\nNotification & Alert System',
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontFamily: 'Medium',
                  align: TextAlign.center,
                  maxLines: 3,
                ),
              ),
              const Spacer(),
              // Features
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      Icons.notifications_active,
                      'Instant Notifications',
                    ),
                    const SizedBox(height: 15),
                    _buildFeatureItem(
                      Icons.timer,
                      '5-Minute Response Timer',
                    ),
                    const SizedBox(height: 15),
                    _buildFeatureItem(
                      Icons.location_on,
                      'Real-Time Location Tracking',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Get Started Button
              ButtonWidget(
                label: 'Get Started',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                color: Colors.white,
                textColor: primary,
                width: 300,
              ),
              const SizedBox(height: 20),
              TextWidget(
                text: 'Powered by MMDA',
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
                fontFamily: 'Regular',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: TextWidget(
            text: text,
            fontSize: 14,
            color: Colors.white,
            fontFamily: 'Medium',
          ),
        ),
      ],
    );
  }
}
