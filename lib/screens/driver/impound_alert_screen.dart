import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class ImpoundAlertScreen extends StatefulWidget {
  final String plateNumber;
  final String reason;
  final String location;

  const ImpoundAlertScreen({
    super.key,
    required this.plateNumber,
    required this.reason,
    required this.location,
  });

  @override
  State<ImpoundAlertScreen> createState() => _ImpoundAlertScreenState();
}

class _ImpoundAlertScreenState extends State<ImpoundAlertScreen> {
  int _remainingSeconds = 300; // 5 minutes
  Timer? _timer;
  bool _isResponded = false;
  String _responseStatus = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
              Colors.red.shade700,
              Colors.red.shade500,
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
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: TextWidget(
                        text: 'IMPOUND ALERT',
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Bold',
                        align: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
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
                      children: [
                        // Timer
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: _remainingSeconds > 60
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _remainingSeconds > 60
                                  ? Colors.orange
                                  : Colors.red,
                              width: 5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.timer,
                                size: 50,
                                color: _remainingSeconds > 60
                                    ? Colors.orange
                                    : Colors.red,
                              ),
                              const SizedBox(height: 10),
                              TextWidget(
                                text: _formatTime(_remainingSeconds),
                                fontSize: 48,
                                color: _remainingSeconds > 60
                                    ? Colors.orange
                                    : Colors.red,
                                fontFamily: 'Bold',
                              ),
                              TextWidget(
                                text: 'Time Remaining',
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'Regular',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Alert Message
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.warning, color: Colors.red, size: 40),
                              const SizedBox(height: 15),
                              TextWidget(
                                text: 'Your vehicle is about to be impounded!',
                                fontSize: 18,
                                color: Colors.red,
                                fontFamily: 'Bold',
                                align: TextAlign.center,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Vehicle Details
                        _buildDetailCard(
                          'Plate Number',
                          widget.plateNumber,
                          Icons.confirmation_number,
                        ),
                        const SizedBox(height: 15),
                        _buildDetailCard(
                          'Reason',
                          widget.reason,
                          Icons.description,
                        ),
                        const SizedBox(height: 15),
                        _buildDetailCard(
                          'Location',
                          widget.location,
                          Icons.location_on,
                        ),
                        const SizedBox(height: 30),
                        // Response Status
                        if (_isResponded)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 30),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: TextWidget(
                                    text: _responseStatus,
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontFamily: 'Bold',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!_isResponded) ...[
                          ButtonWidget(
                            label: "I'm Coming",
                            onPressed: () {
                              setState(() {
                                _isResponded = true;
                                _responseStatus = "You've indicated you're on your way";
                              });
                            },
                            width: double.infinity,
                            color: Colors.orange,
                            icon: const Icon(Icons.directions_run,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 15),
                          ButtonWidget(
                            label: "I'm Here",
                            onPressed: () {
                              setState(() {
                                _isResponded = true;
                                _responseStatus = "You've indicated you're at the vehicle";
                                _timer?.cancel();
                              });
                            },
                            width: double.infinity,
                            color: Colors.green,
                            icon: const Icon(Icons.check, color: Colors.white),
                          ),
                        ],
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

  Widget _buildDetailCard(String label, String value, IconData icon) {
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
            child: Icon(icon, color: primary, size: 24),
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
                const SizedBox(height: 4),
                TextWidget(
                  text: value,
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Bold',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
