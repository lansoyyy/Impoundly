import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_impound_app/screens/enforcer/scan_vehicle_screen.dart';
import 'package:vehicle_impound_app/screens/enforcer/impound_records_screen.dart';
import 'package:vehicle_impound_app/screens/landing_screen.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class EnforcerDashboardScreen extends StatefulWidget {
  const EnforcerDashboardScreen({super.key});

  @override
  State<EnforcerDashboardScreen> createState() =>
      _EnforcerDashboardScreenState();
}

class _EnforcerDashboardScreenState extends State<EnforcerDashboardScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  List<Map<String, dynamic>> _recentViolations = [];
  int _todayViolations = 0;
  int _todayImpounded = 0;
  int _todayTickets = 0;
  int _stolenDetected = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseService.getUserData(user.uid);
      final violations = await FirebaseService.getEnforcerViolations(user.uid);

      // Calculate today's statistics
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);

      int impounded = 0;
      int tickets = 0;
      int stolen = 0;
      List<Map<String, dynamic>> recentList = [];

      for (var violation in violations) {
        final createdAt = violation['createdAt'];
        DateTime? violationDate;

        if (createdAt != null) {
          violationDate = createdAt.toDate();

          // Check if violation is from today
          if (violationDate != null && violationDate.isAfter(todayStart)) {
            if (violation['action'] == 'Immediate Impound') {
              impounded++;
            } else if (violation['action'] == 'Issue Ticket Only') {
              tickets++;
            }

            if (violation['violationType'] == 'Stolen') {
              stolen++;
            }
          }
        }

        // Get recent violations (last 5)
        if (recentList.length < 5) {
          recentList.add(violation);
        }
      }

      setState(() {
        _userData = userData;
        _recentViolations = recentList;
        _todayViolations = violations.where((v) {
          final createdAt = v['createdAt'];
          if (createdAt != null) {
            final date = createdAt.toDate();
            return date.isAfter(todayStart);
          }
          return false;
        }).length;
        _todayImpounded = impounded;
        _todayTickets = tickets;
        _stolenDetected = stolen;
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
                      child: Icon(Icons.badge, color: primary, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: 'MMDA Enforcer',
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
                                  text: _userData?['name'] ?? 'Enforcer',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                        ],
                      ),
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
                        // Statistics
                        TextWidget(
                          text: "Today's Statistics",
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                _todayViolations.toString(),
                                'Today\'s\nViolations',
                                Icons.qr_code_scanner,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildStatCard(
                                _todayImpounded.toString(),
                                'Vehicles\nImpounded',
                                Icons.local_shipping,
                                Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                _todayTickets.toString(),
                                'Tickets\nIssued',
                                Icons.receipt,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildStatCard(
                                _stolenDetected.toString(),
                                'Stolen\nDetected',
                                Icons.warning,
                                Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Quick Actions
                        TextWidget(
                          text: 'Quick Actions',
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        const SizedBox(height: 20),
                        _buildActionButton(
                          'Scan Vehicle',
                          'Scan or input plate number',
                          Icons.qr_code_scanner,
                          primary,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScanVehicleScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildActionButton(
                          'View Records',
                          'Check impound records',
                          Icons.history,
                          Colors.orange,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ImpoundRecordsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        // Recent Activity
                        TextWidget(
                          text: 'Recent Activity',
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        const SizedBox(height: 15),
                        if (_recentViolations.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextWidget(
                                text: 'No recent violations',
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'Regular',
                              ),
                            ),
                          )
                        else
                          ..._recentViolations.map((violation) {
                            final createdAt = violation['createdAt'];
                            String timeAgo = 'Just now';

                            if (createdAt != null) {
                              final date = createdAt.toDate();
                              final diff = DateTime.now().difference(date);

                              if (diff.inDays > 0) {
                                timeAgo =
                                    '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
                              } else if (diff.inHours > 0) {
                                timeAgo =
                                    '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
                              } else if (diff.inMinutes > 0) {
                                timeAgo =
                                    '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
                              }
                            }

                            Color statusColor = Colors.blue;
                            String statusText =
                                violation['action'] ?? 'Unknown';

                            if (violation['action'] == 'Immediate Impound') {
                              statusColor = Colors.red;
                              statusText = 'Impounded';
                            } else if (violation['action'] ==
                                'Issue Ticket Only') {
                              statusColor = Colors.orange;
                              statusText = 'Ticket Issued';
                            } else if (violation['action'] ==
                                'Send Notification') {
                              statusColor = Colors.blue;
                              statusText = 'Notification Sent';
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildActivityCard(
                                violation['plateNumber'] ?? 'N/A',
                                violation['violationType'] ?? 'Unknown',
                                timeAgo,
                                statusText,
                                statusColor,
                              ),
                            );
                          }).toList(),
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

  Widget _buildActionButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
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
                  TextWidget(
                    text: title,
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Bold',
                  ),
                  TextWidget(
                    text: subtitle,
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    String plateNumber,
    String reason,
    String time,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.directions_car, color: primary, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: plateNumber,
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Bold',
                ),
                TextWidget(
                  text: reason,
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontFamily: 'Regular',
                ),
                TextWidget(
                  text: time,
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontFamily: 'Regular',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextWidget(
              text: status,
              fontSize: 11,
              color: statusColor,
              fontFamily: 'Bold',
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
