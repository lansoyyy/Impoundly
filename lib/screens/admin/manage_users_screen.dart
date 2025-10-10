import 'package:flutter/material.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';
import 'package:vehicle_impound_app/widgets/textfield_widget.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<Map<String, dynamic>> drivers = [
    {
      'name': 'John Doe',
      'email': 'john.doe@email.com',
      'phone': '09123456789',
      'plateNumber': 'ABC 1234',
      'status': 'Active',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@email.com',
      'phone': '09987654321',
      'plateNumber': 'XYZ 5678',
      'status': 'Active',
    },
    {
      'name': 'Mark Johnson',
      'email': 'mark.j@email.com',
      'phone': '09111222333',
      'plateNumber': 'DEF 9012',
      'status': 'Suspended',
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
          text: 'Manage Drivers',
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _showAddDriverDialog();
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
            stops: const [0.0, 0.15],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driver = drivers[index];
            return _buildDriverCard(driver, index);
          },
        ),
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver, int index) {
    Color statusColor =
        driver['status'] == 'Active' ? Colors.green : Colors.red;

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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: primary, size: 35),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: driver['name'],
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Bold',
                      ),
                      TextWidget(
                        text: driver['email'],
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Regular',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextWidget(
                    text: driver['status'],
                    fontSize: 11,
                    color: statusColor,
                    fontFamily: 'Bold',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('Phone', driver['phone']),
                ),
                Expanded(
                  child: _buildInfoItem('Plate', driver['plateNumber']),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showEditDriverDialog(driver, index);
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
                      _toggleStatus(index);
                    },
                    icon: Icon(
                      driver['status'] == 'Active'
                          ? Icons.block
                          : Icons.check_circle,
                      size: 18,
                    ),
                    label: TextWidget(
                      text:
                          driver['status'] == 'Active' ? 'Suspend' : 'Activate',
                      fontSize: 12,
                      color: driver['status'] == 'Active'
                          ? Colors.orange
                          : Colors.green,
                      fontFamily: 'Medium',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: driver['status'] == 'Active'
                          ? Colors.orange
                          : Colors.green,
                      side: BorderSide(
                        color: driver['status'] == 'Active'
                            ? Colors.orange
                            : Colors.green,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    _showDeleteDialog(driver, index);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Icon(Icons.delete, size: 18),
                ),
              ],
            ),
          ],
        ),
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

  void _toggleStatus(int index) {
    setState(() {
      drivers[index]['status'] =
          drivers[index]['status'] == 'Active' ? 'Suspended' : 'Active';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${drivers[index]['name']} is now ${drivers[index]['status']}'),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> driver, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: TextWidget(
          text: 'Delete Driver',
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'Bold',
        ),
        content: TextWidget(
          text: 'Are you sure you want to delete ${driver['name']}?',
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
              setState(() {
                drivers.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${driver['name']} has been deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            color: Colors.red,
            width: 100,
            height: 45,
          ),
        ],
      ),
    );
  }

  void _showAddDriverDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final plateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: TextWidget(
          text: 'Add New Driver',
          fontSize: 20,
          color: primary,
          fontFamily: 'Bold',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFieldWidget(
                label: 'Full Name',
                hint: 'Enter driver name',
                controller: nameController,
                borderColor: primary,
                height: 60,
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Email',
                hint: 'Enter email',
                controller: emailController,
                borderColor: primary,
                height: 60,
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Phone',
                hint: 'Enter phone number',
                controller: phoneController,
                borderColor: primary,
                height: 60,
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Plate Number',
                hint: 'Enter plate number',
                controller: plateController,
                borderColor: primary,
                height: 60,
              ),
            ],
          ),
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
            label: 'Add',
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                setState(() {
                  drivers.add({
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'plateNumber': plateController.text,
                    'status': 'Active',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Driver added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            width: 100,
            height: 45,
          ),
        ],
      ),
    );
  }

  void _showEditDriverDialog(Map<String, dynamic> driver, int index) {
    final nameController = TextEditingController(text: driver['name']);
    final emailController = TextEditingController(text: driver['email']);
    final phoneController = TextEditingController(text: driver['phone']);
    final plateController = TextEditingController(text: driver['plateNumber']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: TextWidget(
          text: 'Edit Driver',
          fontSize: 20,
          color: primary,
          fontFamily: 'Bold',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFieldWidget(
                label: 'Full Name',
                hint: 'Enter driver name',
                controller: nameController,
                borderColor: primary,
                height: 60,
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Email',
                hint: 'Enter email',
                controller: emailController,
                borderColor: primary,
                height: 60,
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Phone',
                hint: 'Enter phone number',
                controller: phoneController,
                borderColor: primary,
                height: 60,
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Plate Number',
                hint: 'Enter plate number',
                controller: plateController,
                borderColor: primary,
                height: 60,
              ),
            ],
          ),
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
            label: 'Update',
            onPressed: () {
              setState(() {
                drivers[index]['name'] = nameController.text;
                drivers[index]['email'] = emailController.text;
                drivers[index]['phone'] = phoneController.text;
                drivers[index]['plateNumber'] = plateController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Driver updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            width: 100,
            height: 45,
          ),
        ],
      ),
    );
  }
}
