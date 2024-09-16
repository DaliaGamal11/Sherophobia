import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'set_appointments.dart'; // Import the new file
import '../Tabs/content.dart';

class DoctorHomeTab extends StatefulWidget {
  const DoctorHomeTab({super.key});

  @override
  State<DoctorHomeTab> createState() => _DoctorHomeTabState();
}

class _DoctorHomeTabState extends State<DoctorHomeTab> {
  User? user;
  String username = '';

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        username = user!.displayName ?? user!.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage:
                AssetImage('assets/images/profile.png'), // Provide image path
              ),
              SizedBox(width: 10), // Add spacing between avatar and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Text("DR: "),
                      Text(username,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(72, 132, 151, 1),)
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,SetAppointments.routeName);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Set Available Appointments',style: TextStyle(fontSize: 20),),
                SizedBox(width: 20,),
                Icon(Icons.calendar_month,size: 35)
              ],
            ),
          ),
          SizedBox(height: 35,),
          content(),
        ],
      ),
    );
  }
}