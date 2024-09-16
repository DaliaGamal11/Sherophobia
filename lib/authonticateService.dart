import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sherophopia/Models/signUpModel.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp(signUpModel user, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      // Update the user profile with the username
      await userCredential.user?.updateDisplayName(user.username);

      // Save additional user data in Firestore
      await _firestore.collection('users').doc(user.username).set({
        'username': user.username,
        'email': user.email,
        'birthDate': user.birthDate,
        'role': user.role,
        'password':user.password,
      });

      return null; // Return null if successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return 'An unknown error occurred.';
      }
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }
}
