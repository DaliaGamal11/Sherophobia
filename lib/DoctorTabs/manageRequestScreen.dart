import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageRequestsScreen extends StatefulWidget {
  static String routeName = "manage_requests";

  @override
  _ManageRequestsScreenState createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _creatorEmail; // Internal state for creatorEmail

  Future<String> _getUsername(String userEmail) async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userData = userSnapshot.docs.first;
        return userData['username'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching username: $e');
      return 'Unknown';
    }
  }

  void _acceptRequest(String userEmail, String communityId) async {
    try {
      String username = await _getUsername(userEmail);
      print('Accepting request for userEmail: $userEmail, communityId: $communityId');

      await _firestore.collection('communities').doc(communityId).update({
        'requests': FieldValue.arrayRemove([userEmail]),
        'acceptedRequests': FieldValue.arrayUnion([userEmail]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request accepted!')),
      );

      // Update the UI state to reflect acceptance
      setState(() {}); // This triggers a rebuild of the widget tree

    } catch (e) {
      print('Failed to accept request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept request: $e')),
      );
    }
  }

  void _rejectRequest(String userEmail, String communityId) async {
    try {
      String username = await _getUsername(userEmail);
      print('Rejecting request for userEmail: $userEmail, communityId: $communityId');

      await _firestore.collection('communities').doc(communityId).update({
        'requests': FieldValue.arrayRemove([userEmail]),
        'rejectedRequests': FieldValue.arrayUnion([userEmail]),

      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request rejected!')),
      );
    } catch (e) {
      print('Failed to reject request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject request: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Example: Initialize _creatorEmail from wherever it's fetched (e.g., Firebase Auth, previous screen, etc.)
    _fetchCreatorEmail(); // Call a method to fetch or set the creator's email
  }

  void _fetchCreatorEmail() async {
    // Example: Fetch creator's email from Firebase Authentication or any other source
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Assuming email is stored in user profile or fetched from another source
        String userEmail = user.email ?? ''; // Fetch user's email
        setState(() {
          _creatorEmail = userEmail; // Update _creatorEmail
        });
        print('Initialized _creatorEmail: $_creatorEmail');
      } else {
        // Handle case where user is not logged in or email fetch fails
        print('User not logged in or email fetch failed');
      }
    } catch (e) {
      print('Error fetching creator email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Manage Requests'),
            Spacer(),
            Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)

          ],
        ),
        backgroundColor: Color.fromRGBO(72, 132, 151, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('communities')
            .where('creatorEmail', isEqualTo: _creatorEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No communities found for this creator'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot communitySnapshot = snapshot.data!.docs[index];
              var communityData = communitySnapshot.data() as Map<String, dynamic>;

              List<dynamic>? requests = communityData['requests'] as List<dynamic>?;

              if (requests == null || requests.isEmpty) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 2,
                  child: ListTile(
                    title: Text(communityData['symptomName'] ?? 'Unknown',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('No pending requests'),
                  ),
                );
              }

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 2,
                child: ExpansionTile(
                  title: Text(communityData['symptomName'] ?? 'Unknown',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Pending requests: ${requests.length}'),
                  children: requests.map((userEmail) {
                    return FutureBuilder<String>(
                      future: _getUsername(userEmail),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return ListTile(
                            title: Text(userEmail),
                            trailing: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return ListTile(
                            title: Text(userEmail),
                            subtitle: Text('Error fetching username'),
                          );
                        }

                        String username = snapshot.data ?? 'Unknown';

                        return ListTile(
                          title: Text(username),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check),
                                color: Colors.green,
                                onPressed: () => _acceptRequest(userEmail, communitySnapshot.id),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                color: Colors.red,
                                onPressed: () => _rejectRequest(userEmail, communitySnapshot.id),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
