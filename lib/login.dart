import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sherophopia/DoctorHome.dart';
import 'package:sherophopia/patientHome.dart';
import 'package:sherophopia/SignUp.dart';
import 'package:sherophopia/restPassword.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);
  static const String routeName = "LogIn";

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _signIn() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      // Perform login with email and password
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(

        email: email,
        password: password,
      );

      // Navigate to appropriate home screen based on user role
      User? user = userCredential.user;
      if (user != null) {
        String role = await getUserRole(email); // Fetch user role using email (or username)
        navigateToHomeScreen(role);
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login. Check your credentials and try again.')),
      );
      print('Failed to sign in with error: $e');
    }
  }

  Future<String> getUserRole(String email) async {
    try {
      // Fetch user role from Firestore using username
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document per username
        return querySnapshot.docs.first.data()['role'].toString();
      } else {
        throw Exception('User not found for username: $email');
      }
    } catch (e) {
      print('Error fetching user role: $e');
      throw Exception('Failed to fetch user role');
    }
  }

  void navigateToHomeScreen(String role) {
    // Navigate to appropriate home screen based on user role
    switch (role.toLowerCase()) {
      case 'doctor or therapist':
        Navigator.pushNamed(context, DoctorHome.routeName);
        break;
      case 'patient':
        Navigator.pushNamed(context, PatientHome.routeName); // Assuming the correct route name for patient home
        break;
      default:
        throw Exception('Unknown user role');
    }
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
                      Icon(Icons.login_sharp, size: 40,color: Color.fromRGBO(72, 132, 151, 1)),
                      SizedBox(width: 8.0),
                      Text(
                        "LogIn",
                        style: TextStyle(color: Color.fromRGBO(72, 132, 151, 1), fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Enter your email',
                      suffixIcon: Icon(Icons.alternate_email,color:Color.fromRGBO(72, 132, 151, 1),),
                    fillColor: Colors.white,
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
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _signIn,
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
                      "Log In",
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
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignUp.routeName); // Navigate to sign up screen
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color.fromRGBO(72, 132, 151, 1),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do you forget password?",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PasswordResetScreen()),
                          );
                        },
                        child: Text('Reset Password',style: TextStyle(
                          color: Color.fromRGBO(72, 132, 151, 1),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),),
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
