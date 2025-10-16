import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Map<String, dynamic>> pendingDrivers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingVerifications();
  }

  Future<void> _fetchPendingVerifications() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Driver')
          // .where('status', isEqualTo: 'suspended')
          .get();

      List<Map<String, dynamic>> drivers = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // Format date
        String dateSubmitted = 'N/A';
        if (data['createdAt'] != null) {
          final date = (data['createdAt'] as Timestamp).toDate();
          final months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ];
          dateSubmitted = '${months[date.month - 1]} ${date.day}, ${date.year}';
        }
        data['dateSubmitted'] = dateSubmitted;

        drivers.add(data);
      }

      setState(() {
        pendingDrivers = drivers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading verifications: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: primary),
              )
            : pendingDrivers.isEmpty
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
                _buildDetailRow('Phone', driver['phone'] ?? 'N/A'),
                const SizedBox(height: 10),
                _buildDetailRow(
                    'License Number', driver['licenseNumber'] ?? 'N/A'),
                const SizedBox(height: 20),
                // TextWidget(
                //   text: 'Vehicle Information',
                //   fontSize: 16,
                //   color: primary,
                //   fontFamily: 'Bold',
                // ),
                // const SizedBox(height: 15),
                // _buildDetailRow('Plate Number', driver['plateNumber'] ?? 'N/A'),
                // const SizedBox(height: 10),
                // _buildDetailRow('Vehicle',
                //     '${driver['vehicleMake'] ?? 'N/A'} ${driver['vehicleModel'] ?? 'N/A'}'),
                // const SizedBox(height: 10),
                // _buildDetailRow('OR Number', driver['orNumber'] ?? 'N/A'),
                // const SizedBox(height: 10),
                // _buildDetailRow('CR Number', driver['crNumber'] ?? 'N/A'),
                // const SizedBox(height: 25),
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
            onPressed: () async {
              try {
                // Update user status to active
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(driver['id'])
                    .update({'status': 'active'});

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
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error approving user: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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
            onPressed: () async {
              try {
                // Update user status to rejected and add reason
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(driver['id'])
                    .update({
                  'status': 'rejected',
                  'rejectionReason': reasonController.text,
                });

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
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error rejecting user: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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
