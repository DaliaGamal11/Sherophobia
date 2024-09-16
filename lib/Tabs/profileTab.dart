import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  String? userName; // Variable to store user's username

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();

  }

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final username = user.displayName; // Assuming displayName is set as the username
        if (username != null && username.isNotEmpty) {
          setState(() {
            userName = username;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Username not found')),
          );
        }
      } catch (e) {
        print('Error fetching username: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch username')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not signed in')),
      );
    }
  }
  Future<void> _saveProfileData() async {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _bioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    try {
      if (userName == null) {
        throw 'Username is null';
      }

      final docRef = _firestore.collection('users').doc(userName);
      if (!(await docRef.get()).exists) {
        throw 'Document does not exist for username: $userName';
      }

      await docRef.update({
        'name': _nameController.text,
        'address': _addressController.text,
        'bio': _bioController.text,
        'phone_number': _phoneController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );

      _nameController.clear();
      _addressController.clear();
      _bioController.clear();
      _phoneController.clear();
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(height: 10),
            _buildTextField(_nameController, 'Name', Icons.person),
            const SizedBox(height: 10),
            _buildTextField(_addressController, 'Address', Icons.home),
            const SizedBox(height: 10),
            _buildTextField(_bioController, 'Bio', Icons.info),
            const SizedBox(height: 10),
            _buildTextField(_phoneController, 'Phone Number', Icons.phone),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileData,
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(const Color.fromRGBO(72, 132, 151, 1)),
              ),
              child: const Text(
                'Save Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Enter your $label',
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
