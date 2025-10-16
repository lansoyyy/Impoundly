import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Map<String, dynamic>> drivers = [];
  List<Map<String, dynamic>> filteredDrivers = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  Future<void> _fetchDrivers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Driver')
          .where('status', whereIn: ['active', 'suspended']).get();

      List<Map<String, dynamic>> driversList = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        data['status'] = data['status'] == 'active' ? 'Active' : 'Suspended';
        driversList.add(data);
      }

      setState(() {
        drivers = driversList;
        filteredDrivers = driversList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading drivers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterDrivers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDrivers = List.from(drivers);
      } else {
        filteredDrivers = drivers
            .where((driver) => driver['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
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
          text: 'Manage Drivers',
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add, color: Colors.white),
        //     onPressed: () {
        //       _showAddDriverDialog();
        //     },
        //   ),
        // ],
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
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.all(15),
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
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _filterDrivers(value);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  border: InputBorder.none,
                  hintText: 'Search driver by name...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'Regular',
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 25,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _filterDrivers('');
                          },
                        )
                      : null,
                ),
              ),
            ),
            // Driver List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : filteredDrivers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 100,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 20),
                              TextWidget(
                                text: _searchController.text.isEmpty
                                    ? 'No drivers found'
                                    : 'No drivers match "${_searchController.text}"',
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontFamily: 'Medium',
                              ),
                              if (_searchController.text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterDrivers('');
                                    },
                                    child: TextWidget(
                                      text: 'Clear search',
                                      fontSize: 14,
                                      color: primary,
                                      fontFamily: 'Medium',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          itemCount: filteredDrivers.length,
                          itemBuilder: (context, index) {
                            final driver = filteredDrivers[index];
                            // Find the original index for operations like toggle, edit, delete
                            final originalIndex = drivers.indexWhere(
                              (d) => d['id'] == driver['id'],
                            );
                            return _buildDriverCard(driver, originalIndex);
                          },
                        ),
            ),
          ],
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
                  child: _buildInfoItem('Status',
                      driver['status'] == 'active' ? 'Active' : 'Suspended'),
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

  void _toggleStatus(int index) async {
    try {
      final newStatus =
          drivers[index]['status'] == 'Active' ? 'suspended' : 'active';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(drivers[index]['id'])
          .update({'status': newStatus});

      setState(() {
        drivers[index]['status'] =
            drivers[index]['status'] == 'Active' ? 'Suspended' : 'Active';

        // Update the filtered list as well
        final filteredIndex = filteredDrivers.indexWhere(
          (d) => d['id'] == drivers[index]['id'],
        );
        if (filteredIndex != -1) {
          filteredDrivers[filteredIndex]['status'] = drivers[index]['status'];
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${drivers[index]['name']} is now ${drivers[index]['status']}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(driver['id'])
                    .delete();

                setState(() {
                  drivers.removeAt(index);
                  // Also remove from filtered list
                  filteredDrivers.removeWhere((d) => d['id'] == driver['id']);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${driver['name']} has been deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting user: $e'),
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
                  final newDriver = {
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'status': 'Active',
                  };
                  drivers.add(newDriver);

                  // Add to filtered list if it matches current search
                  if (_searchController.text.isEmpty ||
                      newDriver['name']
                          .toString()
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase())) {
                    filteredDrivers.add(newDriver);
                  }
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
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(driver['id'])
                    .update({
                  'name': nameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text,
                });

                setState(() {
                  drivers[index]['name'] = nameController.text;
                  drivers[index]['email'] = emailController.text;
                  drivers[index]['phone'] = phoneController.text;

                  // Update the filtered list as well
                  final filteredIndex = filteredDrivers.indexWhere(
                    (d) => d['id'] == drivers[index]['id'],
                  );
                  if (filteredIndex != -1) {
                    filteredDrivers[filteredIndex]['name'] =
                        nameController.text;
                    filteredDrivers[filteredIndex]['email'] =
                        emailController.text;
                    filteredDrivers[filteredIndex]['phone'] =
                        phoneController.text;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Driver updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error updating driver: $e'),
                    backgroundColor: Colors.red,
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
}
