import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sherophopia/Widgets/QouteSection.dart';
import '../Widgets/FeelingIcon.dart';
import '../Widgets/sessions.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  User? user;
  String username = '';
  String _profileImageUrl = '';

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
              FeelingIcon(icon: Icons.sentiment_very_satisfied, label: 'Satisfy', onTap: () => _handleFeelingTap(context, 'Satisfy')),
              FeelingIcon(icon: Icons.sentiment_dissatisfied, label: 'Sad', onTap: () => _handleFeelingTap(context, 'Sad')),
              FeelingIcon(icon: Icons.sentiment_very_dissatisfied, label: 'Angry', onTap: () => _handleFeelingTap(context, 'Angry')),
              FeelingIcon(icon: Icons.sentiment_satisfied, label: 'Happy', onTap: () => _handleFeelingTap(context, 'Happy')),
              FeelingIcon(icon: Icons.sentiment_neutral, label: 'Worry', onTap: () => _handleFeelingTap(context, 'Worry')),
              FeelingIcon(icon: Icons.add_circle_outline, label: 'Other', onTap: () => _showBottomSheet(context)),
            ],
          ),
          SizedBox(height: 20),
          QuoteSection(),
          SizedBox(height: 20),
          UpcomingSessions(),
        ],
      ),
    );
  }

  void _handleFeelingTap(BuildContext context, String feeling) {
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
                  // Handle submission
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: 'Your response has been submitted');
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
