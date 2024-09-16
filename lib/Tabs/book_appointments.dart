import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
//right
class BookAppointments extends StatefulWidget {
  static String routeName = "book";

  @override
  _BookAppointmentsState createState() => _BookAppointmentsState();
}

class _BookAppointmentsState extends State<BookAppointments> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _bookSlot(DocumentSnapshot slot) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _firestore.runTransaction((transaction) async {
          DocumentSnapshot freshSnap = await transaction.get(slot.reference);
          transaction.update(freshSnap.reference, {
            'booked': true,
            'patient_email': _emailController.text.trim(), // Store patient email
          });
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
        title: Text('Book Available Slots'),
        backgroundColor: Color.fromRGBO(72, 132, 151, 1),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(),
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
            ),
            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection('available_slots')
                    .where('booked', isEqualTo: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

                      return ListTile(
                        title: Text(
                          '${DateFormat.yMd().format(startTime)}: ${DateFormat.jm().format(startTime)} - ${DateFormat.jm().format(endTime)}',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _bookSlot(slot),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(72, 132, 151, 1),
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                          ),
                          child: Text('Book'),
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
    );
  }
}
