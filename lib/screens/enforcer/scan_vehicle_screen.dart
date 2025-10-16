import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:vehicle_impound_app/screens/enforcer/violation_details_screen.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
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
  bool _isProcessingImage = false;
  Map<String, dynamic>? _vehicleData;
  XFile? _imageFile;

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickAndScanImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        // Crop the image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Plate Number',
              toolbarColor: primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Crop Plate Number',
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _isProcessingImage = true;
            _imageFile = XFile(croppedFile.path);
          });

          await _recognizePlateNumber(XFile(croppedFile.path));
        }
      }
    } catch (e) {
      setState(() {
        _isProcessingImage = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _recognizePlateNumber(XFile image) async {
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      String scannedText = "";
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          // Remove spaces and special characters, keep only alphanumeric
          String cleanedText = line.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
          if (cleanedText.isNotEmpty) {
            scannedText += cleanedText;
          }
        }
      }

      setState(() {
        _isProcessingImage = false;
        if (scannedText.isNotEmpty) {
          _plateNumberController.text = scannedText.toUpperCase();
        }
      });

      if (scannedText.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No text detected. Please try again.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Plate number detected: ${scannedText.toUpperCase()}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isProcessingImage = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scanning image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: TextWidget(
          text: 'Scan Plate Number',
          fontSize: 18,
          color: Colors.black,
          fontFamily: 'Bold',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: primary, size: 30),
              title: TextWidget(
                text: 'Camera',
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Medium',
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAndScanImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: primary, size: 30),
              title: TextWidget(
                text: 'Gallery',
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Medium',
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAndScanImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanVehicle() async {
    if (_plateNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a plate number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isScanning = true;
      _vehicleFound = false;
      _vehicleData = null;
    });

    try {
      // Search for vehicle in Firestore
      final result = await FirebaseService.searchVehicleByPlateNumber(
        _plateNumberController.text.trim().toUpperCase(),
      );

      setState(() {
        _isScanning = false;
      });

      if (result['success']) {
        setState(() {
          _vehicleFound = true;
          _vehicleData = result['vehicleData'];
        });
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.orange, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextWidget(
                      text: 'Vehicle Not Found',
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Bold',
                    ),
                  ),
                ],
              ),
              content: TextWidget(
                text: result['message'],
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Regular',
                maxLines: 5,
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
        }
      }
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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
                      onTap: _isProcessingImage ? null : _showImageSourceDialog,
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
                        child: _isProcessingImage
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: primary),
                                  const SizedBox(height: 15),
                                  TextWidget(
                                    text: 'Processing Image...',
                                    fontSize: 16,
                                    color: primary,
                                    fontFamily: 'Bold',
                                  ),
                                ],
                              )
                            : _imageFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : Column(
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
                                        text: 'Use camera or gallery to scan',
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
