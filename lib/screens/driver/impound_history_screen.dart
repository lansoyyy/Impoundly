import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class ImpoundHistoryScreen extends StatefulWidget {
  const ImpoundHistoryScreen({super.key});

  @override
  State<ImpoundHistoryScreen> createState() => _ImpoundHistoryScreenState();
}

class _ImpoundHistoryScreenState extends State<ImpoundHistoryScreen> {
  // Sample history data
  final List<Map<String, dynamic>> history = [
    {
      'plateNumber': 'ABC 1234',
      'reason': 'Clearing Operation',
      'location': 'EDSA Guadalupe',
      'date': 'Oct 8, 2025',
      'time': '10:30 AM',
      'enforcer': 'Officer Juan Dela Cruz',
      'status': 'Resolved',
      'impoundArea': 'MMDA Compound - Guadalupe',
    },
    {
      'plateNumber': 'ABC 1234',
      'reason': 'Illegal Parking',
      'location': 'Ayala Avenue',
      'date': 'Oct 5, 2025',
      'time': '2:15 PM',
      'enforcer': 'Officer Maria Santos',
      'status': 'Ticket Issued',
      'impoundArea': 'N/A',
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
        child: history.isEmpty
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
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final record = history[index];
                  return _buildHistoryCard(record);
                },
              ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> record) {
    Color statusColor = record['status'] == 'Resolved'
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
                        text: '${record['date']} • ${record['time']}',
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
                    text: record['status'],
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
                  record['reason'],
                ),
                const SizedBox(height: 15),
                _buildDetailRow(
                  Icons.location_on,
                  'Location',
                  record['location'],
                ),
                const SizedBox(height: 15),
                _buildDetailRow(
                  Icons.badge,
                  'Enforcer',
                  record['enforcer'],
                ),
                if (record['impoundArea'] != 'N/A') ...[
                  const SizedBox(height: 15),
                  _buildDetailRow(
                    Icons.warehouse,
                    'Impound Area',
                    record['impoundArea'],
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
