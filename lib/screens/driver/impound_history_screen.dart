import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class ImpoundHistoryScreen extends StatefulWidget {
  const ImpoundHistoryScreen({super.key});

  @override
  State<ImpoundHistoryScreen> createState() => _ImpoundHistoryScreenState();
}

class _ImpoundHistoryScreenState extends State<ImpoundHistoryScreen> {
  List<Map<String, dynamic>> _violations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchViolations();
  }

  Future<void> _fetchViolations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final violations = await FirebaseService.getUserViolations(user.uid);
      setState(() {
        _violations = violations;
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
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          text: 'Impound History',
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
            : _violations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        TextWidget(
                          text: 'No impound history',
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontFamily: 'Medium',
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _violations.length,
                    itemBuilder: (context, index) {
                      final record = _violations[index];
                      return _buildHistoryCard(record);
                    },
                  ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> record) {
    // Format date and time
    String formattedDate = 'N/A';
    String formattedTime = 'N/A';
    
    final createdAt = record['createdAt'];
    if (createdAt != null) {
      final date = createdAt.toDate();
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
      formattedDate = '${months[date.month - 1]} ${date.day}, ${date.year}';
      
      final hour =
          date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final period = date.hour >= 12 ? 'PM' : 'AM';
      formattedTime =
          '${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
    }
    
    Color statusColor = record['status'] == 'responded'
        ? Colors.green
        : record['status'] == 'Ticket Issued'
            ? Colors.orange
            : Colors.red;

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
              color: primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.directions_car, color: primary, size: 30),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: record['plateNumber'],
                        fontSize: 20,
                        color: primary,
                        fontFamily: 'Bold',
                      ),
                      TextWidget(
                        text: '$formattedDate • $formattedTime',
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'Regular',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextWidget(
                    text: record['status'] == 'responded' ? 'Resolved' : 
                          record['status'] == 'pending' ? 'Pending' : 'Processed',
                    fontSize: 12,
                    color: statusColor,
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
              children: [
                _buildDetailRow(
                  Icons.description,
                  'Reason',
                  record['violationType'] ?? 'N/A',
                ),
                const SizedBox(height: 15),
                _buildDetailRow(
                  Icons.location_on,
                  'Location',
                  record['location'] ?? 'N/A',
                ),
                const SizedBox(height: 15),
                _buildDetailRow(
                  Icons.local_shipping,
                  'Action',
                  record['action'] ?? 'N/A',
                ),
                if (record['notes'] != null && record['notes'].toString().isNotEmpty) ...[
                  const SizedBox(height: 15),
                  _buildDetailRow(
                    Icons.note,
                    'Notes',
                    record['notes'],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primary, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: label,
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: 'Regular',
              ),
              const SizedBox(height: 2),
              TextWidget(
                text: value,
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'Medium',
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
