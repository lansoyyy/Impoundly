import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';
import 'package:vehicle_impound_app/widgets/textfield_widget.dart';

class RegisterVehicleScreen extends StatefulWidget {
  const RegisterVehicleScreen({super.key});

  @override
  State<RegisterVehicleScreen> createState() => _RegisterVehicleScreenState();
}

class _RegisterVehicleScreenState extends State<RegisterVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateNumberController = TextEditingController();
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleColorController = TextEditingController();
  final _orNumberController = TextEditingController();
  final _crNumberController = TextEditingController();

  @override
  void dispose() {
    _plateNumberController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
    _orNumberController.dispose();
    _crNumberController.dispose();
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
          text: 'Register Vehicle',
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
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 24),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextWidget(
                            text:
                                'Please provide accurate vehicle information for registration',
                            fontSize: 13,
                            color: Colors.white,
                            fontFamily: 'Regular',
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        TextWidget(
                          text: 'Vehicle Information',
                          fontSize: 18,
                          color: primary,
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
                        const SizedBox(height: 15),
                        TextFieldWidget(
                          label: 'Vehicle Make',
                          hint: 'e.g., Toyota',
                          controller: _vehicleMakeController,
                          borderColor: primary,
                          prefix: Icon(Icons.business, color: primary),
                        ),
                        const SizedBox(height: 15),
                        TextFieldWidget(
                          label: 'Vehicle Model',
                          hint: 'e.g., Vios',
                          controller: _vehicleModelController,
                          borderColor: primary,
                          prefix: Icon(Icons.directions_car, color: primary),
                        ),
                        const SizedBox(height: 15),
                        TextFieldWidget(
                          label: 'Vehicle Color',
                          hint: 'e.g., White',
                          controller: _vehicleColorController,
                          borderColor: primary,
                          prefix: Icon(Icons.palette, color: primary),
                        ),
                        const SizedBox(height: 30),
                        TextWidget(
                          text: 'Document Information',
                          fontSize: 18,
                          color: primary,
                          fontFamily: 'Bold',
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          label: 'OR Number',
                          hint: 'Official Receipt Number',
                          controller: _orNumberController,
                          borderColor: primary,
                          prefix: Icon(Icons.receipt_long, color: primary),
                        ),
                        const SizedBox(height: 15),
                        TextFieldWidget(
                          label: 'CR Number',
                          hint: 'Certificate of Registration Number',
                          controller: _crNumberController,
                          borderColor: primary,
                          prefix: Icon(Icons.description, color: primary),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ButtonWidget(
                            label: 'Register Vehicle',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // TODO: Implement vehicle registration
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 60,
                                    ),
                                    content: TextWidget(
                                      text:
                                          'Vehicle registered successfully!',
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'Medium',
                                      align: TextAlign.center,
                                    ),
                                    actions: [
                                      Center(
                                        child: ButtonWidget(
                                          label: 'Done',
                                          onPressed: () {
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
                            },
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
