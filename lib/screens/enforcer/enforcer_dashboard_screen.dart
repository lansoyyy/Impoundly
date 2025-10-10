import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/screens/enforcer/scan_vehicle_screen.dart';
import 'package:vehicle_impound_app/screens/enforcer/impound_records_screen.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class EnforcerDashboardScreen extends StatefulWidget {
  const EnforcerDashboardScreen({super.key});

  @override
  State<EnforcerDashboardScreen> createState() =>
      _EnforcerDashboardScreenState();
}

class _EnforcerDashboardScreenState extends State<EnforcerDashboardScreen> {
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
                          TextWidget(
                            text: 'Officer Juan Dela Cruz',
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Bold',
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                      onPressed: () {
                        // TODO: Settings
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
                                '12',
                                'Vehicles\nScanned',
                                Icons.qr_code_scanner,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildStatCard(
                                '3',
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
                                '9',
                                'Tickets\nIssued',
                                Icons.receipt,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildStatCard(
                                '0',
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
                        _buildActivityCard(
                          'ABC 1234',
                          'Clearing Operation',
                          '10 minutes ago',
                          'Ticket Issued',
                          Colors.orange,
                        ),
                        const SizedBox(height: 10),
                        _buildActivityCard(
                          'XYZ 5678',
                          'Illegal Parking',
                          '25 minutes ago',
                          'Impounded',
                          Colors.red,
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
}
