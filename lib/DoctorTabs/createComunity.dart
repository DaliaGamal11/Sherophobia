import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateCommunityScreen extends StatefulWidget {
  static String routeName = "create";

  @override
  _CreateCommunityScreenState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _urlController = TextEditingController();
  String _symptomName = '';
  String _description = '';
  String _sanitizedUrl = '';
  bool _isValidUrl = false;
  String _confirmUrl = '';

  void _sanitizeAndDisplayUrl() {
    final userInput = _urlController.text.trim();

    if (Uri.parse(userInput).isAbsolute) {
      setState(() {
        _sanitizedUrl = userInput;
        _isValidUrl = true;
        _confirmUrl = 'Valid URL';
      });
    } else {
      setState(() {
        _confirmUrl = 'Invalid URL';
        _isValidUrl = false;
      });
    }
  }

  void _createCommunity() async {
    User? user = _auth.currentUser;

    if (_symptomName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Symptom Name is required.')),
      );
      return;
    }

    if (_description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Description is required.')),
      );
      return;
    }

    if (!_isValidUrl) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a valid URL.')),
      );
      return;
    }

    if (user != null) {
      try {
        await _firestore.collection('communities').add({
          'symptomName': _symptomName,
          'description': _description,
          'link': _sanitizedUrl,
          'creatorEmail': user.email,
          'members': [user.email], // Include creator as the first member
          'requests': [], // Initialize empty requests array
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Community created successfully!')),
        );
        // Navigate to community details page or refresh community list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create community: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Create Community'),
            Spacer(),
            Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)
          ],
        ),
        backgroundColor: Color.fromRGBO(72, 132, 151, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Symptom Name'),
                onChanged: (value) {
                  setState(() {
                    _symptomName = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'Enter URL',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromRGBO(72, 132, 151, 1),
                  ),
                ),
                onPressed: _sanitizeAndDisplayUrl,
                child: Text('Sanitize URL'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Sanitized URL: $_confirmUrl',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(72, 132, 151, 1),
                      ),
                    ),
                    onPressed: _createCommunity,
                    child: Text('Create Community', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
