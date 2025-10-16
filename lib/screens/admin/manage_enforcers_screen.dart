import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_impound_app/utils/colors.dart';
import 'package:vehicle_impound_app/widgets/button_widget.dart';
import 'package:vehicle_impound_app/widgets/text_widget.dart';
import 'package:vehicle_impound_app/widgets/textfield_widget.dart';

class ManageEnforcersScreen extends StatefulWidget {
  const ManageEnforcersScreen({super.key});

  @override
  State<ManageEnforcersScreen> createState() => _ManageEnforcersScreenState();
}

class _ManageEnforcersScreenState extends State<ManageEnforcersScreen> {
  List<Map<String, dynamic>> enforcers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEnforcers();
  }

  Future<void> _fetchEnforcers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Enforcer')
          .get();

      List<Map<String, dynamic>> enforcersList = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        data['status'] = data['status'] == 'active' ? 'Active' : 'Suspended';
        enforcersList.add(data);
      }

      setState(() {
        enforcers = enforcersList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading enforcers: $e'),
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
          text: 'Manage Enforcers',
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add, color: Colors.white),
        //     onPressed: () {
        //       _showAddEnforcerDialog();
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : enforcers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        TextWidget(
                          text: 'No enforcers found',
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontFamily: 'Medium',
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: enforcers.length,
                    itemBuilder: (context, index) {
                      final enforcer = enforcers[index];
                      return _buildEnforcerCard(enforcer, index);
                    },
                  ),
      ),
    );
  }

  Widget _buildEnforcerCard(Map<String, dynamic> enforcer, int index) {
    Color statusColor =
        enforcer['status'] == 'Active' ? Colors.green : Colors.red;

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
                  backgroundColor: Colors.green.withOpacity(0.1),
                  child: Icon(Icons.badge, color: Colors.green, size: 35),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: enforcer['name'],
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Bold',
                      ),
                      TextWidget(
                        text: enforcer['email'],
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
                    text: enforcer['status'],
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
                  child: _buildInfoItem('Phone', enforcer['phone']),
                ),
                // Expanded(
                //   child: _buildInfoItem('Badge', enforcer['badgeNumber']),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showEditEnforcerDialog(enforcer, index);
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
                      enforcer['status'] == 'Active'
                          ? Icons.block
                          : Icons.check_circle,
                      size: 18,
                    ),
                    label: TextWidget(
                      text: enforcer['status'] == 'Active'
                          ? 'Suspend'
                          : 'Activate',
                      fontSize: 12,
                      color: enforcer['status'] == 'Active'
                          ? Colors.orange
                          : Colors.green,
                      fontFamily: 'Medium',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: enforcer['status'] == 'Active'
                          ? Colors.orange
                          : Colors.green,
                      side: BorderSide(
                        color: enforcer['status'] == 'Active'
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
                    _showDeleteDialog(enforcer, index);
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
          enforcers[index]['status'] == 'Active' ? 'suspended' : 'active';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(enforcers[index]['id'])
          .update({'status': newStatus});

      setState(() {
        enforcers[index]['status'] =
            enforcers[index]['status'] == 'Active' ? 'Suspended' : 'Active';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${enforcers[index]['name']} is now ${enforcers[index]['status']}'),
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

  void _showDeleteDialog(Map<String, dynamic> enforcer, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: TextWidget(
          text: 'Delete Enforcer',
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'Bold',
        ),
        content: TextWidget(
          text: 'Are you sure you want to delete ${enforcer['name']}?',
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
                    .doc(enforcer['id'])
                    .delete();

                setState(() {
                  enforcers.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${enforcer['name']} has been deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting enforcer: $e'),
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

  void _showAddEnforcerDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final badgeController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: TextWidget(
          text: 'Add New Enforcer',
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
                hint: 'Enter enforcer name',
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
                label: 'Username',
                hint: 'Enter username',
                controller: usernameController,
                borderColor: primary,
                height: 60,
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Password',
                hint: 'Enter password',
                controller: passwordController,
                borderColor: primary,
                height: 60,
                isObscure: true,
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
                  enforcers.add({
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'status': 'Active',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enforcer added successfully'),
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

  void _showEditEnforcerDialog(Map<String, dynamic> enforcer, int index) {
    final nameController = TextEditingController(text: enforcer['name']);
    final emailController = TextEditingController(text: enforcer['email']);
    final phoneController = TextEditingController(text: enforcer['phone']);
    final badgeController =
        TextEditingController(text: enforcer['badgeNumber']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: TextWidget(
          text: 'Edit Enforcer',
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
                hint: 'Enter enforcer name',
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
                    .doc(enforcer['id'])
                    .update({
                  'name': nameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text,
                });

                setState(() {
                  enforcers[index]['name'] = nameController.text;
                  enforcers[index]['email'] = emailController.text;
                  enforcers[index]['phone'] = phoneController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enforcer updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error updating enforcer: $e'),
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
