import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class ImpoundRecordsScreen extends StatefulWidget {
  const ImpoundRecordsScreen({super.key});

  @override
  State<ImpoundRecordsScreen> createState() => _ImpoundRecordsScreenState();
}

class _ImpoundRecordsScreenState extends State<ImpoundRecordsScreen> {
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _allRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final violations = await FirebaseService.getEnforcerViolations(user.uid);
      setState(() {
        _allRecords = violations;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredRecords {
    if (_selectedFilter == 'All') return _allRecords;

    String filterAction = _selectedFilter;
    if (_selectedFilter == 'Impounded') {
      filterAction = 'Immediate Impound';
    } else if (_selectedFilter == 'Ticket Issued') {
      filterAction = 'Issue Ticket Only';
    }

    return _allRecords
        .where((record) => record['action'] == filterAction)
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primary),
                    )
                  : filteredRecords.isEmpty
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
        : record['status'] == 'pending'
            ? Colors.orange
            : Colors.blue;

    Color actionColor = record['action'] == 'Immediate Impound'
        ? Colors.red
        : record['action'] == 'Issue Ticket Only'
            ? Colors.orange
            : Colors.blue;

    String actionText = record['action'] ?? 'Unknown';
    if (record['action'] == 'Immediate Impound') {
      actionText = 'Impounded';
    } else if (record['action'] == 'Issue Ticket Only') {
      actionText = 'Ticket Issued';
    } else if (record['action'] == 'Send Notification') {
      actionText = 'Notification Sent';
    }

    String statusText = record['status'] ?? 'Unknown';
    if (record['status'] == 'responded') {
      statusText = 'Resolved';
    } else if (record['status'] == 'pending') {
      statusText = 'Pending';
    } else if (record['status'] == 'processed') {
      statusText = 'Processed';
    }

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
                        text: 'Violation Record',
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
                        text: statusText,
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
                        text: actionText,
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
                _buildDetailRow(Icons.description, 'Reason',
                    record['violationType'] ?? 'N/A'),
                const SizedBox(height: 12),
                _buildDetailRow(
                    Icons.location_on, 'Location', record['location'] ?? 'N/A'),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.calendar_today, 'Date & Time',
                    '$formattedDate • $formattedTime'),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.reply, 'Driver Response',
                    record['driverResponse'] ?? 'No Response'),
                if (record['notes'] != null &&
                    record['notes'].toString().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.note, 'Notes', record['notes']),
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
