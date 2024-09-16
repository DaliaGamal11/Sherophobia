import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sherophopia/DoctorTabs/manageRequestScreen.dart';

class JoinCommunityScreen extends StatefulWidget {
  static String routeName = "join";
  final String? initialText; // Add this line

  JoinCommunityScreen({Key? key, required this.initialText}) : super(key: key);

  @override
  _JoinCommunityScreenState createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _usernameController; // Declare as late
  String? _username; // Define _username as nullable

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
        text: widget.initialText ?? ''); // Initialize with initialText
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _requestToJoinCommunity(String communityId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('communities').doc(communityId).update({
          'requests': FieldValue.arrayUnion([user.email]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request sent successfully!')),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send request: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(72, 132, 151, 1),
        title: Text('Join Community'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('communities').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var communities = snapshot.data!.docs;
          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              var community = communities[index];
              var communityData = community.data() as Map<String, dynamic>?;

              var link = communityData != null &&
                  communityData.containsKey('link')
                  ? communityData['link']
                  : null;

              User? user = _auth.currentUser;
              var acceptedRequests = communityData != null &&
                  communityData.containsKey('acceptedRequests')
                  ? communityData['acceptedRequests']
                  : null;
              bool requestAccepted = acceptedRequests != null &&
                  acceptedRequests[user!.email] != null;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(
                      communityData != null ? communityData['symptomName'] ??
                          'Unknown' : 'Unknown'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(communityData != null
                          ? communityData['description'] ??
                          'No description available'
                          : 'No description available'),
                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {
                          if (requestAccepted && link != null &&
                              link.isNotEmpty) {
                            _launchURL(link);
                          }
                        },
                        child: Text(
                          link ?? 'No meeting link provided',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(
                          72, 132, 151, 1)),
                    ),
                    onPressed: () {
                      _requestToJoinCommunity(community.id);
                    },
                    child: Text('Join'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}