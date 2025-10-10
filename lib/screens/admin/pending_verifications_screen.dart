import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class PendingVerificationsScreen extends StatefulWidget {
  const PendingVerificationsScreen({super.key});

  @override
  State<PendingVerificationsScreen> createState() =>
      _PendingVerificationsScreenState();
}

class _PendingVerificationsScreenState
    extends State<PendingVerificationsScreen> {
  // Sample pending verifications
  List<Map<String, dynamic>> pendingDrivers = [
    {
      'name': 'John Doe',
      'email': 'john.doe@email.com',
      'phone': '09123456789',
      'plateNumber': 'ABC 1234',
      'vehicleMake': 'Toyota',
      'vehicleModel': 'Vios',
      'orNumber': 'OR-123456',
      'crNumber': 'CR-789012',
      'licenseNumber': 'N01-12-345678',
      'dateSubmitted': 'Oct 10, 2025',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@email.com',
      'phone': '09987654321',
      'plateNumber': 'XYZ 5678',
      'vehicleMake': 'Honda',
      'vehicleModel': 'Civic',
      'orNumber': 'OR-234567',
      'crNumber': 'CR-890123',
      'licenseNumber': 'N01-23-456789',
      'dateSubmitted': 'Oct 10, 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          text: 'Pending Verifications',
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primary,
              Colors.white,
            ],
            stops: const [0.0, 0.15],
          ),
        ),
        child: pendingDrivers.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    TextWidget(
                      text: 'No pending verifications',
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontFamily: 'Medium',
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: pendingDrivers.length,
                itemBuilder: (context, index) {
                  final driver = pendingDrivers[index];
                  return _buildVerificationCard(driver, index);
                },
              ),
      ),
    );
  }

  Widget _buildVerificationCard(Map<String, dynamic> driver, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primary.withOpacity(0.2),
                  child: Icon(Icons.person, color: primary, size: 35),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: driver['name'],
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Bold',
                      ),
                      TextWidget(
                        text: driver['email'],
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Regular',
                      ),
                      TextWidget(
                        text: 'Submitted: ${driver['dateSubmitted']}',
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontFamily: 'Regular',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextWidget(
                    text: 'PENDING',
                    fontSize: 11,
                    color: Colors.orange,
                    fontFamily: 'Bold',
                  ),
                ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Personal Information',
                  fontSize: 16,
                  color: primary,
                  fontFamily: 'Bold',
                ),
                const SizedBox(height: 15),
                _buildDetailRow('Phone', driver['phone']),
                const SizedBox(height: 10),
                _buildDetailRow('License Number', driver['licenseNumber']),
                const SizedBox(height: 20),
                TextWidget(
                  text: 'Vehicle Information',
                  fontSize: 16,
                  color: primary,
                  fontFamily: 'Bold',
                ),
                const SizedBox(height: 15),
                _buildDetailRow('Plate Number', driver['plateNumber']),
                const SizedBox(height: 10),
                _buildDetailRow('Vehicle',
                    '${driver['vehicleMake']} ${driver['vehicleModel']}'),
                const SizedBox(height: 10),
                _buildDetailRow('OR Number', driver['orNumber']),
                const SizedBox(height: 10),
                _buildDetailRow('CR Number', driver['crNumber']),
                const SizedBox(height: 25),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        label: 'Reject',
                        onPressed: () {
                          _showRejectDialog(driver, index);
                        },
                        color: Colors.red,
                        width: double.infinity,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ButtonWidget(
                        label: 'Approve',
                        onPressed: () {
                          _showApproveDialog(driver, index);
                        },
                        color: Colors.green,
                        width: double.infinity,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: TextWidget(
            text: label,
            fontSize: 13,
            color: Colors.grey[600],
            fontFamily: 'Regular',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextWidget(
            text: value,
            fontSize: 13,
            color: Colors.black,
            fontFamily: 'Medium',
          ),
        ),
      ],
    );
  }

  void _showApproveDialog(Map<String, dynamic> driver, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 15),
            TextWidget(
              text: 'Approve Registration',
              fontSize: 20,
              color: Colors.black,
              fontFamily: 'Bold',
            ),
          ],
        ),
        content: TextWidget(
          text:
              'Are you sure you want to approve ${driver['name']}\'s registration?',
          fontSize: 14,
          color: Colors.grey[600],
          fontFamily: 'Regular',
          align: TextAlign.center,
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
            label: 'Approve',
            onPressed: () {
              setState(() {
                pendingDrivers.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${driver['name']} has been approved!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            color: Colors.green,
            width: 120,
            height: 45,
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(Map<String, dynamic> driver, int index) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Icon(Icons.cancel, color: Colors.red, size: 60),
            const SizedBox(height: 15),
            TextWidget(
              text: 'Reject Registration',
              fontSize: 20,
              color: Colors.black,
              fontFamily: 'Bold',
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: 'Please provide a reason for rejection:',
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Regular',
            ),
            const SizedBox(height: 15),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
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
            label: 'Reject',
            onPressed: () {
              setState(() {
                pendingDrivers.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${driver['name']} has been rejected.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            color: Colors.red,
            width: 120,
            height: 45,
          ),
        ],
      ),
    );
  }
}
