import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/screens/driver/register_vehicle_screen.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  // Sample data
  final List<Map<String, dynamic>> vehicles = [
    {
      'plateNumber': 'ABC 1234',
      'make': 'Toyota',
      'model': 'Vios',
      'color': 'White',
      'status': 'Active',
      'orNumber': 'OR-123456',
      'crNumber': 'CR-789012',
    },
    {
      'plateNumber': 'XYZ 5678',
      'make': 'Honda',
      'model': 'Civic',
      'color': 'Black',
      'status': 'Active',
      'orNumber': 'OR-345678',
      'crNumber': 'CR-901234',
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
              );
            },
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
            stops: const [0.0, 0.2],
          ),
        ),
        child: vehicles.isEmpty
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
                            builder: (context) => const RegisterVehicleScreen(),
                          ),
                        );
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
                  return _buildVehicleCard(vehicle);
                },
              ),
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
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
                      text: '${vehicle['make']} ${vehicle['model']}',
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
                child: _buildInfoItem('Color', vehicle['color']),
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
                    // TODO: Edit vehicle
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
                    _showDeleteDialog(vehicle['plateNumber']);
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

  void _showDeleteDialog(String plateNumber) {
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
            onPressed: () {
              // TODO: Implement delete
              Navigator.pop(context);
            },
            color: Colors.red,
            width: 100,
            height: 45,
          ),
        ],
      ),
    );
  }
}
