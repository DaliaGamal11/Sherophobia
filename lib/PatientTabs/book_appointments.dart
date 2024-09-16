import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookAppointments extends StatefulWidget {
  static String routeName = "book";

  @override
  _BookAppointmentsState createState() => _BookAppointmentsState();
}

class _BookAppointmentsState extends State<BookAppointments> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await canLaunch(uri.toString())) {
      throw 'Could not launch $url';
    }
    await launch(uri.toString());
  }

  Future<void> _bookSlot(DocumentSnapshot slot) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Check if slot is already booked
        bool isBooked = slot['booked'] ?? false;
        if (isBooked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This slot has already been booked')),
          );
          return;
        }

        // Update Firestore document
        await slot.reference.update({
          'booked': true,
          'patient_email': _emailController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Slot booked successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book the slot')),
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
            Text('Book One-to-One session',style: TextStyle(fontSize: 20),),
            Spacer(),
            Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)

          ],
        ),
        backgroundColor: Color.fromRGBO(72, 132, 151, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('available_slots').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No available slots'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot slot = snapshot.data!.docs[index];
                        DateTime startTime = (slot['start_time'] as Timestamp).toDate();
                        DateTime endTime = (slot['end_time'] as Timestamp).toDate();
                        String creatorEmail = slot['creator_email'] ?? 'Unknown';
                        String location = slot['location'] ?? 'Unknown';
                        bool booked = slot['booked'] ?? false;
                        String sessionType=slot['session_type']??'Unknown';

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),

                          ),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date & Time: ${DateFormat.yMd().format(startTime)} ${DateFormat.jm().format(startTime)} - ${DateFormat.jm().format(endTime)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text('Doctor Email: $creatorEmail'),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text("Session Type: "),
                                    Text(
                                      sessionType,
                                      style: TextStyle(
                                        color: sessionType == "Online" ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                GestureDetector(
                                  onTap: () {
                                    _launchURL(location);
                                  },
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            trailing: booked
                                ? Text('Already booked')
                                : ElevatedButton(
                              onPressed: () {
                                _bookSlot(slot);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(72, 132, 151, 1),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Book'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
