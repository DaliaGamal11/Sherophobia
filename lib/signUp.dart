import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sherophopia/DoctorHome.dart';
import 'package:sherophopia/login.dart';
import 'package:sherophopia/patientHome.dart';
import 'authonticateService.dart';
import 'package:sherophopia/Models/signUpModel.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const String routeName = "SignUp";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _dropDownValue;
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1950),
      firstDate: DateTime(1950),
      lastDate: DateTime(2008),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color.fromRGBO(72, 132, 151, 1), // Header background color
            hintColor: Color.fromRGBO(72, 132, 151, 1), // Selected day color
            colorScheme: ColorScheme.light(
              primary: Color.fromRGBO(72, 132, 151, 1), // Header background color
              onPrimary: Colors.white, // Header text and icon color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color.fromRGBO(72, 132, 151, 1), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _signUp() async {
    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (_usernameController==null || _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please enter your username')),
      );
      return;
    }
    if (_emailController==null || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please enter your email')),
      );
      return;
    }
    if (_passwordController==null || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please enter your password')),
      );
      return;
    }

    // Validate email format
    final emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email format')),
      );
      return;
    }


    // Create user object
    signUpModel user = signUpModel(
      username: _usernameController.text,
      email: _emailController.text,
      birthDate: _birthDateController.text,
      role: _dropDownValue,
      password: _passwordController.text,
    );

    // Check if username already exists
    bool usernameExists = await _checkUsernameExists(user.username);
    if (usernameExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username already exists. Please choose a different username.')),
      );
      return;
    }

    // Attempt to sign up and store user data in Firestore
    AuthService authService = AuthService();
    String? result = await authService.signUp(user, _passwordController.text);

    if (result == null) {
      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.username)
          .set({
        'username': user.username,
        'email': user.email,
        'birthDate': user.birthDate,
        'role': user.role,
        'password': user.password,
      });

      // Navigate based on user role
      if (user.role == 'Doctor or Therapist') {
        Navigator.pushNamed(context, DoctorHome.routeName);
      } else if (user.role == 'Patient') {
        Navigator.pushNamed(context, PatientHome.routeName);
      }
    } else {
      // Show error message if signup fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }


  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<bool> _checkUsernameExists(String username) async {
    var snapshot =
    await FirebaseFirestore.instance.collection('users').doc(username).get();
    return snapshot.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(72, 132, 151, 1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add, color: Color.fromRGBO(72, 132, 151, 1)),
                      SizedBox(width: 8.0),
                      Text(
                        "Sign Up",
                        style: TextStyle(color: Color.fromRGBO(72, 132, 151, 1), fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Enter your username',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Enter Your Email',
                      fillColor: Colors.white,
                      suffixIcon: Icon(Icons.alternate_email,color:Color.fromRGBO(72, 132, 151, 1),),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Enter Password',
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Color.fromRGBO(72, 132, 151, 1),
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Confirm Password',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Select Birth Date',
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(Icons.calendar_today, color: Color.fromRGBO(72, 132, 151, 1)),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    hint: _dropDownValue == null
                        ? Text('Role')
                        : Text(
                      _dropDownValue,
                      style: TextStyle(
                        color: Color.fromRGBO(72, 132, 151, 1),
                      ),
                    ),
                    isExpanded: true,
                    iconSize: 30.0,
                    items: ['Doctor or Therapist', 'Patient'].map(
                          (val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _dropDownValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _signUp,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(72, 132, 151, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LogIn.routeName);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Color.fromRGBO(72, 132, 151, 1),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
