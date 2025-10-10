import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';
import 'package:vehicle_impound_app/widgets/textfield_widget.dart';

class ViolationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> vehicleData;

  const ViolationDetailsScreen({
    super.key,
    required this.vehicleData,
  });

  @override
  State<ViolationDetailsScreen> createState() => _ViolationDetailsScreenState();
}

class _ViolationDetailsScreenState extends State<ViolationDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedViolationType = 'Clearing Operation';
  String _selectedAction = 'Send Notification';

  final List<String> violationTypes = [
    'Clearing Operation',
    'Illegal Parking',
    'Obstruction',
    'Accident',
    'Fire Hazard',
    'Flood/Typhoon',
    'Earthquake',
    'Other Emergency',
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
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
          text: 'Violation Details',
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
            stops: const [0.0, 0.25],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Info Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.directions_car, color: primary, size: 35),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: widget.vehicleData['plateNumber'],
                              fontSize: 22,
                              color: primary,
                              fontFamily: 'Bold',
                            ),
                            TextWidget(
                              text:
                                  '${widget.vehicleData['make']} ${widget.vehicleData['model']}',
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'Regular',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Violation Form
                Container(
                  padding: const EdgeInsets.all(25),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Violation Information',
                        fontSize: 18,
                        color: primary,
                        fontFamily: 'Bold',
                      ),
                      const SizedBox(height: 20),
                      TextWidget(
                        text: 'Violation Type',
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Medium',
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedViolationType,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down, color: primary),
                            style: TextStyle(
                              fontFamily: 'Medium',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            items: violationTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: TextWidget(
                                  text: type,
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Medium',
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedViolationType = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFieldWidget(
                        label: 'Location',
                        hint: 'Enter current location',
                        controller: _locationController,
                        borderColor: primary,
                        prefix: Icon(Icons.location_on, color: primary),
                      ),
                      const SizedBox(height: 20),
                      TextFieldWidget(
                        label: 'Additional Notes',
                        hint: 'Enter any additional information',
                        controller: _notesController,
                        borderColor: primary,
                        maxLine: 4,
                        height: 120,
                        prefix: Icon(Icons.notes, color: primary),
                        hasValidator: false,
                      ),
                      const SizedBox(height: 25),
                      TextWidget(
                        text: 'Action to Take',
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Medium',
                      ),
                      const SizedBox(height: 15),
                      _buildActionOption(
                        'Send Notification',
                        'Driver will receive alert with 5-minute timer',
                        Icons.notifications_active,
                      ),
                      const SizedBox(height: 10),
                      _buildActionOption(
                        'Immediate Impound',
                        'Vehicle will be impounded immediately',
                        Icons.local_shipping,
                      ),
                      const SizedBox(height: 10),
                      _buildActionOption(
                        'Issue Ticket Only',
                        'Issue violation ticket without impound',
                        Icons.receipt,
                      ),
                      const SizedBox(height: 30),
                      ButtonWidget(
                        label: 'Submit',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _showConfirmationDialog();
                          }
                        },
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionOption(String title, String description, IconData icon) {
    final isSelected = _selectedAction == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAction = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? primary : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: title,
                    fontSize: 15,
                    color: isSelected ? primary : Colors.black,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(height: 3),
                  TextWidget(
                    text: description,
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: primary, size: 24),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Icon(
              _selectedAction == 'Send Notification'
                  ? Icons.notifications_active
                  : _selectedAction == 'Immediate Impound'
                      ? Icons.local_shipping
                      : Icons.receipt,
              color: primary,
              size: 50,
            ),
            const SizedBox(height: 15),
            TextWidget(
              text: 'Confirm Action',
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
              text: 'You are about to $_selectedAction for:',
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Regular',
              align: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  TextWidget(
                    text: widget.vehicleData['plateNumber'],
                    fontSize: 18,
                    color: primary,
                    fontFamily: 'Bold',
                  ),
                  TextWidget(
                    text: _selectedViolationType,
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Regular',
                  ),
                ],
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
            label: 'Confirm',
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog();
            },
            width: 120,
            height: 45,
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 15),
            TextWidget(
              text: 'Success!',
              fontSize: 22,
              color: Colors.green,
              fontFamily: 'Bold',
            ),
          ],
        ),
        content: TextWidget(
          text: _selectedAction == 'Send Notification'
              ? 'Notification sent to driver successfully!'
              : _selectedAction == 'Immediate Impound'
                  ? 'Vehicle impound record created!'
                  : 'Ticket issued successfully!',
          fontSize: 14,
          color: Colors.grey[600],
          fontFamily: 'Regular',
          align: TextAlign.center,
        ),
        actions: [
          Center(
            child: ButtonWidget(
              label: 'Done',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 150,
            ),
          ),
        ],
      ),
    );
  }
}
