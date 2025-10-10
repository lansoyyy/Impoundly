import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/screens/driver/impound_alert_screen.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample notifications
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Impound Alert',
      'message': 'Your vehicle ABC 1234 is about to be impounded',
      'time': '2 minutes ago',
      'type': 'alert',
      'isRead': false,
      'plateNumber': 'ABC 1234',
      'reason': 'Clearing Operation',
      'location': 'EDSA Guadalupe',
    },
    {
      'title': 'Vehicle Registered',
      'message': 'XYZ 5678 has been successfully registered',
      'time': '1 hour ago',
      'type': 'success',
      'isRead': false,
    },
    {
      'title': 'System Update',
      'message': 'New features are now available',
      'time': '2 hours ago',
      'type': 'info',
      'isRead': true,
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
          text: 'Notifications',
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in notifications) {
                  notification['isRead'] = true;
                }
              });
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
        child: notifications.isEmpty
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
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(notification);
                },
              ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    IconData icon;
    Color iconColor;

    switch (notification['type']) {
      case 'alert':
        icon = Icons.warning;
        iconColor = Colors.red;
        break;
      case 'success':
        icon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      default:
        icon = Icons.info;
        iconColor = Colors.blue;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          notification['isRead'] = true;
        });

        if (notification['type'] == 'alert') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImpoundAlertScreen(
                plateNumber: notification['plateNumber'],
                reason: notification['reason'],
                location: notification['location'],
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: notification['isRead']
              ? Colors.white
              : primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: notification['isRead']
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
                          text: notification['title'],
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                      ),
                      if (!notification['isRead'])
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
                    text: notification['message'],
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
                        text: notification['time'],
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
