import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_impound_app/screens/driver/register_vehicle_screen.dart';
import 'package:vehicle_impound_app/services/firebase_service.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';
import 'package:vehicle_impound_app/widgets/textfield_widget.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  List<Map<String, dynamic>> vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userVehicles = await FirebaseService.getUserVehicles(user.uid);
      setState(() {
        vehicles = userVehicles;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshVehicles() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchVehicles();
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
          text: 'My Vehicles',
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterVehicleScreen(),
                ),
              ).then((_) => _refreshVehicles());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshVehicles,
        child: Container(
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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : vehicles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car_outlined,
                            size: 100,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          TextWidget(
                            text: 'No vehicles registered',
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontFamily: 'Medium',
                          ),
                          const SizedBox(height: 30),
                          ButtonWidget(
                            label: 'Register Vehicle',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterVehicleScreen(),
                                ),
                              ).then((_) => _refreshVehicles());
                            },
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];
                        return _buildVehicleCard(vehicle, vehicle['id']);
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle, String vehicleId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
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
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.directions_car, color: primary, size: 35),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: vehicle['plateNumber'],
                      fontSize: 22,
                      color: primary,
                      fontFamily: 'Bold',
                    ),
                    TextWidget(
                      text:
                          '${vehicle['vehicleMake']} ${vehicle['vehicleModel']}',
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontFamily: 'Medium',
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextWidget(
                  text: vehicle['status'],
                  fontSize: 12,
                  color: Colors.green,
                  fontFamily: 'Bold',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('Color', vehicle['vehicleColor']),
              ),
              Expanded(
                child: _buildInfoItem('OR Number', vehicle['orNumber']),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInfoItem('CR Number', vehicle['crNumber']),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showEditDialog(vehicle, vehicleId);
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: TextWidget(
                    text: 'Edit',
                    fontSize: 14,
                    color: primary,
                    fontFamily: 'Medium',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primary,
                    side: BorderSide(color: primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDeleteDialog(vehicle['plateNumber'], vehicleId);
                  },
                  icon: const Icon(Icons.delete, size: 18),
                  label: TextWidget(
                    text: 'Delete',
                    fontSize: 14,
                    color: Colors.red,
                    fontFamily: 'Medium',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
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
          fontSize: 14,
          color: Colors.black,
          fontFamily: 'Medium',
        ),
      ],
    );
  }

  void _showDeleteDialog(String plateNumber, String vehicleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: TextWidget(
          text: 'Delete Vehicle',
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'Bold',
        ),
        content: TextWidget(
          text: 'Are you sure you want to delete $plateNumber?',
          fontSize: 14,
          color: Colors.grey[600],
          fontFamily: 'Regular',
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
            label: 'Delete',
            onPressed: () async {
              Navigator.pop(context);
              final success = await FirebaseService.deleteVehicle(vehicleId);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vehicle deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                _refreshVehicles();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete vehicle'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            color: Colors.red,
            width: 100,
            height: 45,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> vehicle, String vehicleId) {
    final plateNumberController =
        TextEditingController(text: vehicle['plateNumber']);
    final vehicleMakeController =
        TextEditingController(text: vehicle['vehicleMake']);
    final vehicleModelController =
        TextEditingController(text: vehicle['vehicleModel']);
    final vehicleColorController =
        TextEditingController(text: vehicle['vehicleColor']);
    final orNumberController = TextEditingController(text: vehicle['orNumber']);
    final crNumberController = TextEditingController(text: vehicle['crNumber']);

    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: TextWidget(
            text: 'Edit Vehicle',
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'Bold',
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFieldWidget(
                      label: 'Plate Number',
                      hint: 'e.g., ABC 1234',
                      controller: plateNumberController,
                      borderColor: primary,
                      textCapitalization: TextCapitalization.characters,
                      prefix: Icon(Icons.confirmation_number, color: primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter plate number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      label: 'Vehicle Make',
                      hint: 'e.g., Toyota',
                      controller: vehicleMakeController,
                      borderColor: primary,
                      prefix: Icon(Icons.business, color: primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter vehicle make';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      label: 'Vehicle Model',
                      hint: 'e.g., Vios',
                      controller: vehicleModelController,
                      borderColor: primary,
                      prefix: Icon(Icons.directions_car, color: primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter vehicle model';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      label: 'Vehicle Color',
                      hint: 'e.g., White',
                      controller: vehicleColorController,
                      borderColor: primary,
                      prefix: Icon(Icons.palette, color: primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter vehicle color';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      label: 'OR Number',
                      hint: 'Official Receipt Number',
                      controller: orNumberController,
                      borderColor: primary,
                      prefix: Icon(Icons.receipt_long, color: primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter OR number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      label: 'CR Number',
                      hint: 'Certificate of Registration Number',
                      controller: crNumberController,
                      borderColor: primary,
                      prefix: Icon(Icons.description, color: primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CR number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: TextWidget(
                text: 'Cancel',
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Medium',
              ),
            ),
            ButtonWidget(
              label: 'Update',
              onPressed: isLoading
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;

                      setState(() {
                        isLoading = true;
                      });

                      final updateData = {
                        'plateNumber': plateNumberController.text.trim(),
                        'vehicleMake': vehicleMakeController.text.trim(),
                        'vehicleModel': vehicleModelController.text.trim(),
                        'vehicleColor': vehicleColorController.text.trim(),
                        'orNumber': orNumberController.text.trim(),
                        'crNumber': crNumberController.text.trim(),
                      };

                      final success = await FirebaseService.updateVehicle(
                          vehicleId, updateData);

                      setState(() {
                        isLoading = false;
                      });

                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vehicle updated successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        _refreshVehicles();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to update vehicle'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              color: primary,
              width: 100,
              height: 45,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
