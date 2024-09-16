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
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
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
        title: Row(
          children: [
            Text('Join Community'),
            Spacer(),
            Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)
          ],
        ),
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
              var acceptedRequests = communityData != null && communityData.containsKey('acceptedRequests')
                  ? List<String>.from(communityData['acceptedRequests'])
                  : [];
              var rejectedRequests = communityData != null && communityData.containsKey('rejectedRequests')
                  ? List<String>.from(communityData['rejectedRequests'])
                  : [];
              var pending = communityData != null && communityData.containsKey('requests')
                  ? List<String>.from(communityData['requests'])
                  : [];

              bool requestAccepted = acceptedRequests.contains(user?.email);
              bool requestRejected = rejectedRequests.contains(user?.email);
              bool pendingRequest = pending.contains(user?.email);



              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Text('Topic : '),
                          Text(
                              communityData != null ? communityData['symptomName'] ??
                                  'Unknown' : 'Unknown',style: TextStyle(fontWeight:FontWeight.bold),),
                        ],
                      ),
                      Text('Doctor Email : '),
                      Text(
                          communityData != null ? communityData['creatorEmail'] ??
                              'Unknown' : 'Unknown'),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(communityData != null
                          ? communityData['description'] ??
                          'No description available'
                          : 'No description available'),
                      SizedBox(height: 8.0),
                      if (requestAccepted)
                        Column(
                          children: [
                            Row(
                              children: [
                                Text("Status : "),
                                Text("You are accepted join now",style: TextStyle(color: Colors.green),),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchURL(link);
                              },
                              child: Text(
                                link,
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (pendingRequest)
                        Row(
                          children: [
                            Text("Status : "),
                            Text("You are not accepted yet",style: TextStyle(color: Colors.orange),),
                          ],
                        ),
                      if (requestRejected)
                        Row(
                          children: [
                            Text("Status : "),
                            Text("You are rejected",style: TextStyle(color: Colors.red),),
                          ],
                        )
                    ],
                  ),
                  trailing: Builder(
                    builder: (context) {
                      if (pendingRequest||requestAccepted||requestRejected) {
                        return SizedBox.shrink(); // Return an empty widget if the button should not be displayed

                      } else {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromRGBO(72, 132, 151, 1)),
                          ),
                          onPressed: () {
                            _requestToJoinCommunity(community.id);
                          },
                          child: Text('Join'),
                        );                      }
                    },
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
