import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUsViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _message = '';
  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;

  void setName(String name) {
    _name = name;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setMessage(String message) {
    _message = message;
  }

  Future<void> submit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _isSubmitting = true;
      notifyListeners();
      try {
        await FirebaseFirestore.instance.collection('messages').doc(_name).set({
          'name': _name,
          'email': _email,
          'message': _message,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message sent successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      } finally {
        _isSubmitting = false;
        notifyListeners();
      }
    }
  }
}
