import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/screens/enforcer/violation_details_screen.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';
import 'package:vehicle_impound_app/widgets/textfield_widget.dart';

class ScanVehicleScreen extends StatefulWidget {
  const ScanVehicleScreen({super.key});

  @override
  State<ScanVehicleScreen> createState() => _ScanVehicleScreenState();
}

class _ScanVehicleScreenState extends State<ScanVehicleScreen> {
  final _plateNumberController = TextEditingController();
  bool _isScanning = false;
  bool _vehicleFound = false;
  Map<String, dynamic>? _vehicleData;

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  void _scanVehicle() {
    if (_plateNumberController.text.isEmpty) return;

    setState(() {
      _isScanning = true;
    });

    // Simulate scanning delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isScanning = false;
        _vehicleFound = true;
        _vehicleData = {
          'plateNumber': _plateNumberController.text.toUpperCase(),
          'owner': 'John Doe',
          'make': 'Toyota',
          'model': 'Vios',
          'color': 'White',
          'status': 'Active',
          'isStolen': false,
        };
      });
    });
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
          text: 'Scan Vehicle',
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
            stops: const [0.0, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              // Scanner Card
              Container(
                padding: const EdgeInsets.all(30),
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
                    GestureDetector(
                      onTap: () {
                        // TODO: Open camera scanner
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: TextWidget(
                              text: 'Camera Scanner',
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Bold',
                            ),
                            content: TextWidget(
                              text:
                                  'Camera scanner will be implemented with actual camera integration',
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'Regular',
                            ),
                            actions: [
                              ButtonWidget(
                                label: 'OK',
                                onPressed: () => Navigator.pop(context),
                                width: 100,
                                height: 45,
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: primary.withOpacity(0.3),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              size: 80,
                              color: primary,
                            ),
                            const SizedBox(height: 15),
                            TextWidget(
                              text: 'Tap to Scan Plate Number',
                              fontSize: 16,
                              color: primary,
                              fontFamily: 'Bold',
                            ),
                            const SizedBox(height: 5),
                            TextWidget(
                              text: 'Use camera to scan vehicle plate',
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Regular',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextWidget(
                            text: 'OR',
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Medium',
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    const SizedBox(height: 30),
                    TextWidget(
                      text: 'Enter Plate Number Manually',
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Bold',
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      label: 'Plate Number',
                      hint: 'e.g., ABC 1234',
                      controller: _plateNumberController,
                      borderColor: primary,
                      textCapitalization: TextCapitalization.characters,
                      prefix: Icon(Icons.confirmation_number, color: primary),
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      label: _isScanning ? 'Scanning...' : 'Search Vehicle',
                      onPressed: _isScanning ? null : _scanVehicle,
                      width: double.infinity,
                      isLoading: _isScanning,
                    ),
                  ],
                ),
              ),
              // Vehicle Details (if found)
              if (_vehicleFound && _vehicleData != null) ...[
                const SizedBox(height: 30),
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
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 30),
                          const SizedBox(width: 10),
                          TextWidget(
                            text: 'Vehicle Found',
                            fontSize: 20,
                            color: Colors.green,
                            fontFamily: 'Bold',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_vehicleData!['isStolen']) ...[
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red, size: 30),
                              const SizedBox(width: 15),
                              Expanded(
                                child: TextWidget(
                                  text: 'ALERT: This vehicle is reported as STOLEN!',
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontFamily: 'Bold',
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      _buildDetailRow('Plate Number', _vehicleData!['plateNumber']),
                      Divider(color: Colors.grey[300]),
                      _buildDetailRow('Owner', _vehicleData!['owner']),
                      Divider(color: Colors.grey[300]),
                      _buildDetailRow(
                          'Vehicle', '${_vehicleData!['make']} ${_vehicleData!['model']}'),
                      Divider(color: Colors.grey[300]),
                      _buildDetailRow('Color', _vehicleData!['color']),
                      Divider(color: Colors.grey[300]),
                      _buildDetailRow('Status', _vehicleData!['status']),
                      const SizedBox(height: 30),
                      ButtonWidget(
                        label: 'Proceed to Violation Details',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViolationDetailsScreen(
                                vehicleData: _vehicleData!,
                              ),
                            ),
                          );
                        },
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: label,
            fontSize: 14,
            color: Colors.grey[600],
            fontFamily: 'Regular',
          ),
          TextWidget(
            text: value,
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'Bold',
          ),
        ],
      ),
    );
  }
}
