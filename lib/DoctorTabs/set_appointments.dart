import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetAppointments extends StatefulWidget {
  static String routeName = "set";

  @override
  _SetAppointmentsState createState() => _SetAppointmentsState();
}

class _SetAppointmentsState extends State<SetAppointments> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _typeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> _getUser() async {
    return _auth.currentUser;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2024),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color.fromRGBO(72, 132, 151, 1),
            hintColor: Color.fromRGBO(72, 132, 151, 1),
            colorScheme: ColorScheme.light(
              primary: Color.fromRGBO(72, 132, 151, 1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color.fromRGBO(72, 132, 151, 1),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 47),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromRGBO(72, 132, 151, 1),
              onSurface: Color.fromRGBO(72, 132, 151, 1),
            ),
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Color.fromRGBO(72, 132, 151, 1),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _startTime != null &&
        _endTime != null) {
      final startDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
      final endDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      final User? user = await _getUser();

      if (user != null && user.email != null) {
        String location = _locationController.text.trim(); // Get location from TextField

        if (location.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter a location')),
          );
          return;
        }
        String session = _typeController.text.trim(); // Get location from TextField

        if (session.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter session type')),
          );
          return;
        }

        await FirebaseFirestore.instance.collection('available_slots').add({
          'start_time': startDateTime,
          'end_time': endDateTime,
          'creator_email': user.email,
          'booked': false,
          'location': location, // Use location entered by user
          'session_type':session,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Available slot added successfully')),
        );

        setState(() {
          _selectedDate = null;
          _startTime = null;
          _endTime = null;
          _locationController.clear(); // Clear the location TextField
          _typeController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Set Available Appointments',style: TextStyle(fontSize: 20),),
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
          child: ListView(
            children: <Widget>[
              ListTile(
                key: ValueKey('date'),
                title: Text(_selectedDate == null
                    ? 'No date chosen!'
                    : DateFormat.yMd().format(_selectedDate!)),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                key: ValueKey('start_time'),
                title: Text(_startTime == null
                    ? 'No start time chosen!'
                    : _startTime!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, true),
              ),
              ListTile(
                key: ValueKey('end_time'),
                title: Text(_endTime == null
                    ? 'No end time chosen!'
                    : _endTime!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, false),
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: 'session',
                  hintText: 'Enter the session type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter session type ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location or URL',
                  hintText: 'Enter the location or URL',
                  suffixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location or URL';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitAppointment,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(72, 132, 151, 1),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
                child: Text('Set Available Slot'),
              ),
              SizedBox(height: 40),
              Image(image: AssetImage('assets/images/Work time-cuate.png'))
            ],
          ),
        ),
      ),
    );
  }
}
