import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/screens/admin/pending_verifications_screen.dart';
import 'package:vehicle_impound_app/screens/admin/manage_users_screen.dart';
import 'package:vehicle_impound_app/screens/admin/manage_enforcers_screen.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
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
                      child: Icon(Icons.admin_panel_settings,
                          color: primary, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: 'Administrator',
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontFamily: 'Regular',
                          ),
                          TextWidget(
                            text: 'Admin Dashboard',
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Bold',
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white, size: 28),
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
                          text: 'Overview',
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        const SizedBox(height: 20),
                        // Statistics Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                '8',
                                'Pending\nVerifications',
                                Icons.pending_actions,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildStatCard(
                                '156',
                                'Total\nDrivers',
                                Icons.person,
                                Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                '24',
                                'Total\nEnforcers',
                                Icons.badge,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildStatCard(
                                '342',
                                'Total\nRecords',
                                Icons.history,
                                Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Management Options
                        TextWidget(
                          text: 'Management',
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        const SizedBox(height: 20),
                        _buildManagementCard(
                          'Pending Verifications',
                          'Review and approve driver registrations',
                          Icons.verified_user,
                          Colors.orange,
                          8,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PendingVerificationsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildManagementCard(
                          'Manage Drivers',
                          'Add, edit, or remove driver accounts',
                          Icons.people,
                          Colors.blue,
                          null,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ManageUsersScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildManagementCard(
                          'Manage Enforcers',
                          'Add, edit, or remove enforcer accounts',
                          Icons.badge,
                          Colors.green,
                          null,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ManageEnforcersScreen(),
                              ),
                            );
                          },
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

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 10),
          TextWidget(
            text: value,
            fontSize: 28,
            color: color,
            fontFamily: 'Bold',
          ),
          const SizedBox(height: 5),
          TextWidget(
            text: label,
            fontSize: 12,
            color: color,
            fontFamily: 'Medium',
            align: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    int? badge,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
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
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextWidget(
                          text: title,
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextWidget(
                            text: badge.toString(),
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'Bold',
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: subtitle,
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: TextWidget(
              text: 'Logout',
              fontSize: 14,
              color: Colors.red,
              fontFamily: 'Bold',
            ),
          ),
        ],
      ),
    );
  }
}
