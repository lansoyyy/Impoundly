import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_impound_app/screens/driver/impound_alert_screen.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
          text: 'Notifications',
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        actions: [
          if (_violations.any((v) => v['status'] == 'pending'))
            TextButton(
              onPressed: () {
                // Mark all as read functionality can be implemented later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications marked as read'),
                  ),
                );
              },
              child: TextWidget(
                text: 'Mark all read',
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Medium',
              ),
            ),
        ],
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
                          Icons.notifications_none,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        TextWidget(
                          text: 'No notifications',
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
                      final violation = _violations[index];
                      return _buildNotificationCard(violation);
                    },
                  ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> violation) {
    // Calculate time ago
    String timeAgo = 'Just now';
    final createdAt = violation['createdAt'];
    if (createdAt != null) {
      final date = createdAt.toDate();
      final diff = DateTime.now().difference(date);
      
      if (diff.inDays > 0) {
        timeAgo = '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
      } else if (diff.inHours > 0) {
        timeAgo = '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
      } else if (diff.inMinutes > 0) {
        timeAgo = '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
      }
    }

    IconData icon;
    Color iconColor;
    String title;
    String message;
    bool isRead = violation['status'] != 'pending';

    if (violation['status'] == 'pending') {
      icon = Icons.warning;
      iconColor = Colors.red;
      title = 'Impound Alert';
      message = 'Your vehicle ${violation['plateNumber']} - ${violation['violationType']} at ${violation['location']}';
    } else if (violation['status'] == 'responded') {
      icon = Icons.check_circle;
      iconColor = Colors.green;
      title = 'Violation Resolved';
      message = '${violation['plateNumber']} - ${violation['violationType']}';
    } else {
      icon = Icons.info;
      iconColor = Colors.blue;
      title = 'Violation Record';
      message = '${violation['plateNumber']} - ${violation['violationType']}';
    }

    return GestureDetector(
      onTap: () {
        if (violation['status'] == 'pending') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImpoundAlertScreen(
                plateNumber: violation['plateNumber'] ?? 'N/A',
                reason: violation['violationType'] ?? 'N/A',
                location: violation['location'] ?? 'N/A',
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isRead
                ? Colors.grey.withOpacity(0.3)
                : primary.withOpacity(0.3),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
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
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: message,
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 5),
                      TextWidget(
                        text: timeAgo,
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontFamily: 'Regular',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
