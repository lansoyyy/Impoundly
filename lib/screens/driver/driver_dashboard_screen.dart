import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_impound_app/screens/driver/register_vehicle_screen.dart';
import 'package:vehicle_impound_app/screens/driver/my_vehicles_screen.dart';
import 'package:vehicle_impound_app/screens/driver/notification_screen.dart';
import 'package:vehicle_impound_app/screens/driver/impound_history_screen.dart';
import 'package:vehicle_impound_app/screens/landing_screen.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseService.getUserData(user.uid);
      final vehicles = await FirebaseService.getUserVehicles(user.uid);
      setState(() {
        _userData = userData;
        _vehicles = vehicles;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: primary, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: 'Welcome Back!',
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontFamily: 'Regular',
                          ),
                          _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : TextWidget(
                                  text: _userData?['name'] ?? 'Driver',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Stack(
                        children: [
                          const Icon(Icons.notifications,
                              color: Colors.white, size: 28),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: TextWidget(
                                text: '3',
                                fontSize: 10,
                                color: Colors.white,
                                fontFamily: 'Bold',
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout,
                          color: Colors.white, size: 28),
                      onPressed: () {
                        _showLogoutDialog();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Main Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: 'Quick Actions',
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickActionCard(
                                'Register\nVehicle',
                                Icons.add_circle_outline,
                                primary,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterVehicleScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildQuickActionCard(
                                'My\nVehicles',
                                Icons.directions_car,
                                Colors.orange,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MyVehiclesScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        TextWidget(
                          text: 'Vehicle Status',
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        const SizedBox(height: 15),
                        _vehicles.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.grey[600],
                                      size: 24,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: TextWidget(
                                        text: 'No vehicles registered yet',
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontFamily: 'Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: _vehicles
                                    .take(3) // Show only first 3 vehicles
                                    .map((vehicle) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: _buildVehicleStatusCard(
                                            vehicle['plateNumber'],
                                            '${vehicle['vehicleMake']} ${vehicle['vehicleModel']}',
                                            vehicle['status'],
                                            vehicle['status'] == 'active'
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ))
                                    .toList(),
                              ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'Recent Activity',
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'Bold',
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ImpoundHistoryScreen(),
                                  ),
                                );
                              },
                              child: TextWidget(
                                text: 'View All',
                                fontSize: 14,
                                color: primary,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildActivityCard(
                          'No Recent Activity',
                          'Your vehicles are safe',
                          Icons.check_circle,
                          Colors.green,
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
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 135,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            TextWidget(
              text: title,
              fontSize: 14,
              color: color,
              fontFamily: 'Bold',
              align: TextAlign.center,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleStatusCard(
    String plateNumber,
    String vehicleModel,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.directions_car, color: primary, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: plateNumber,
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Bold',
                ),
                TextWidget(
                  text: vehicleModel,
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Regular',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextWidget(
              text: status,
              fontSize: 12,
              color: statusColor,
              fontFamily: 'Bold',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Bold',
                ),
                TextWidget(
                  text: description,
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Regular',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: TextWidget(
          text: 'Logout',
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'Bold',
        ),
        content: TextWidget(
          text: 'Are you sure you want to logout?',
          fontSize: 14,
          color: Colors.grey[600],
          fontFamily: 'Regular',
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
            label: 'Logout',
            onPressed: () async {
              await FirebaseService.logoutUser();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LandingScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            color: Colors.red,
            width: 100,
            height: 45,
          ),
        ],
      ),
    );
  }
}
