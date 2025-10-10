import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vehicle_impound_app/screens/driver/driver_dashboard_screen.dart';
import 'package:vehicle_impound_app/screens/enforcer/enforcer_dashboard_screen.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

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
              primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  text: 'Select Your Role',
                  fontSize: 28,
                  color: primary,
                  fontFamily: 'Bold',
                ),
                const SizedBox(height: 10),
                TextWidget(
                  text: 'Choose how you want to use Impoundly',
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Regular',
                  align: TextAlign.center,
                ),
                const SizedBox(height: 50),
                _buildRoleCard(
                  context,
                  'Driver',
                  'Register your vehicle and receive\nreal-time impound notifications',
                  Icons.directions_car,
                  () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DriverDashboardScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                _buildRoleCard(
                  context,
                  'Enforcer',
                  'Scan vehicles and manage\nimpound operations',
                  Icons.badge,
                  () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EnforcerDashboardScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primary.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: primary,
                size: 40,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: title,
                    fontSize: 22,
                    color: primary,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: description,
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
