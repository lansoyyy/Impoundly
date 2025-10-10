import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class ImpoundRecordsScreen extends StatefulWidget {
  const ImpoundRecordsScreen({super.key});

  @override
  State<ImpoundRecordsScreen> createState() => _ImpoundRecordsScreenState();
}

class _ImpoundRecordsScreenState extends State<ImpoundRecordsScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> records = [
    {
      'plateNumber': 'ABC 1234',
      'owner': 'John Doe',
      'reason': 'Clearing Operation',
      'location': 'EDSA Guadalupe',
      'date': 'Oct 10, 2025',
      'time': '10:30 AM',
      'action': 'Ticket Issued',
      'status': 'Resolved',
      'driverResponse': "I'm Here",
    },
    {
      'plateNumber': 'XYZ 5678',
      'owner': 'Jane Smith',
      'reason': 'Illegal Parking',
      'location': 'Ayala Avenue',
      'date': 'Oct 10, 2025',
      'time': '9:15 AM',
      'action': 'Impounded',
      'status': 'Pending',
      'driverResponse': 'No Response',
    },
    {
      'plateNumber': 'DEF 9012',
      'owner': 'Mark Johnson',
      'reason': 'Obstruction',
      'location': 'Ortigas Center',
      'date': 'Oct 9, 2025',
      'time': '3:45 PM',
      'action': 'Ticket Issued',
      'status': 'Resolved',
      'driverResponse': "I'm Coming",
    },
  ];

  List<Map<String, dynamic>> get filteredRecords {
    if (_selectedFilter == 'All') return records;
    return records
        .where((record) => record['action'] == _selectedFilter)
        .toList();
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
          text: 'Impound Records',
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
            stops: const [0.0, 0.2],
          ),
        ),
        child: Column(
          children: [
            // Filter Tabs
            Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All'),
                    const SizedBox(width: 10),
                    _buildFilterChip('Impounded'),
                    const SizedBox(width: 10),
                    _buildFilterChip('Ticket Issued'),
                  ],
                ),
              ),
            ),
            // Records List
            Expanded(
              child: filteredRecords.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 100,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          TextWidget(
                            text: 'No records found',
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontFamily: 'Medium',
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: filteredRecords.length,
                      itemBuilder: (context, index) {
                        final record = filteredRecords[index];
                        return _buildRecordCard(record);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: TextWidget(
          text: label,
          fontSize: 14,
          color: isSelected ? Colors.white : Colors.grey[700],
          fontFamily: 'Medium',
        ),
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    Color statusColor = record['status'] == 'Resolved'
        ? Colors.green
        : record['status'] == 'Pending'
            ? Colors.orange
            : Colors.red;

    Color actionColor = record['action'] == 'Impounded'
        ? Colors.red
        : record['action'] == 'Ticket Issued'
            ? Colors.orange
            : Colors.blue;

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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.2),
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
                        text: record['plateNumber'],
                        fontSize: 18,
                        color: primary,
                        fontFamily: 'Bold',
                      ),
                      TextWidget(
                        text: record['owner'],
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Regular',
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextWidget(
                        text: record['status'],
                        fontSize: 11,
                        color: statusColor,
                        fontFamily: 'Bold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: actionColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextWidget(
                        text: record['action'],
                        fontSize: 11,
                        color: actionColor,
                        fontFamily: 'Bold',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailRow(Icons.description, 'Reason', record['reason']),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.location_on, 'Location', record['location']),
                const SizedBox(height: 12),
                _buildDetailRow(
                    Icons.calendar_today, 'Date & Time', '${record['date']} • ${record['time']}'),
                const SizedBox(height: 12),
                _buildDetailRow(
                    Icons.reply, 'Driver Response', record['driverResponse']),
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
        Icon(icon, color: Colors.grey[600], size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: label,
                fontSize: 11,
                color: Colors.grey[600],
                fontFamily: 'Regular',
              ),
              TextWidget(
                text: value,
                fontSize: 13,
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
