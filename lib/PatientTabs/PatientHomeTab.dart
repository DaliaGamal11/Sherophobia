import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sherophopia/PatientTabs/book_appointments.dart';
import 'package:sherophopia/Widgets/QouteSection.dart';
import '../Widgets/FeelingIcon.dart';
import '../Tabs/content.dart';

class PatientHomeTab extends StatefulWidget {
  @override
  _PatientHomeTabState createState() => _PatientHomeTabState();
}

class _PatientHomeTabState extends State<PatientHomeTab> {
  User? user;
  String username = '';
  String _profileImageUrl = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _feelingController = TextEditingController();

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
  void _saveFeeling(String feeling) async {
    try {
      print('The Feeling is $feeling');

      // Check if the document already exists
      final docRef = _firestore.collection('feelings').doc(username);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // If document doesn't exist, create it with initial array
        await docRef.set({
          'feelings': [
            {
              'feeling': feeling,
              'timestamp': DateTime.now(),
            }
          ],
        });
      } else {
        // If document exists, update the array
        await docRef.update({
          'feelings': FieldValue.arrayUnion([
            {
              'feeling': feeling,
              'timestamp': DateTime.now(),
            }
          ]),
        });
      }

      Fluttertoast.showToast(msg: 'Feeling saved successfully');
    } catch (e, stackTrace) {
      print('Error saving feeling: $e');
      print('Stack trace: $stackTrace');
      Fluttertoast.showToast(msg: 'Error saving your feeling. Please try again.');
    }
  }



  @override
  void dispose() {
    _feelingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = Iconsax.items.entries.toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: _profileImageUrl.isNotEmpty
                    ? NetworkImage(_profileImageUrl)
                    : AssetImage('assets/images/profile.png') as ImageProvider,
              ),
              SizedBox(width: 10), // Add spacing between avatar and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back', style: TextStyle(fontSize: 16)),
                  Text(username, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('How are you feeling today?', style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FeelingIcon(icon: Icons.sentiment_very_satisfied, label: 'Satisfy', onTap: () => _handleFeelingTap(context, 'Satisfy'),),
              FeelingIcon(icon: Icons.sentiment_dissatisfied, label: 'Sad', onTap: () => _handleFeelingTap(context, 'Sad')),
              FeelingIcon(icon: Icons.sentiment_very_dissatisfied, label: 'Angry', onTap: () => _handleFeelingTap(context, 'Angry')),
              FeelingIcon(icon: Icons.sentiment_satisfied, label: 'Happy', onTap: () => _handleFeelingTap(context, 'Happy')),
              FeelingIcon(icon: Icons.sentiment_neutral, label: 'Worry', onTap: () => _handleFeelingTap(context, 'Worry')),
              FeelingIcon(icon: Icons.add_reaction_outlined, label: 'Other', onTap: () => _showBottomSheet(context)),
            ],
          ),
          SizedBox(height: 20),
          QuoteSection(),
          SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(72, 132, 151, 1),)
            ),
            onPressed: () {
             Navigator.pushNamed(context, BookAppointments.routeName);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Book Appointments',style: TextStyle(fontSize: 25),),
                SizedBox(width: 20,),
                Icon(Icons.calendar_month_outlined,size: 35,)
              ],
            ),
          ),
          SizedBox(height: 35,),
          content(),
        ],
      ),
    );
  }

  void _handleFeelingTap(BuildContext context, String feeling) {
    _saveFeeling(feeling);
    Fluttertoast.showToast(msg: 'You are feeling $feeling');

  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50,),
              Text('Please describe your feeling',style: TextStyle(fontWeight: FontWeight.w700),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _feelingController,
                  cursorColor:Color.fromRGBO(72, 132, 151, 1) ,
                  decoration: InputDecoration(hintText: 'Type here...',
                    border: UnderlineInputBorder(),hoverColor:Color.fromRGBO(72, 132, 151, 1) , ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(backgroundColor:
                MaterialStatePropertyAll(Color.fromRGBO(72, 132, 151, 1))),
                  onPressed: () {
                    String feeling = _feelingController.text;
                    print('Feeling entered: $feeling');
                    if (feeling.isNotEmpty) {
                      _saveFeeling(feeling);
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'Your response has been submitted');
                      _feelingController.clear();
                    } else {
                      Fluttertoast.showToast(msg: 'Please enter your feeling');
                    }
                  },
                  child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
