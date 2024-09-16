import 'package:flutter/material.dart';

class FeelingIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  FeelingIcon({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 40),
          Text(label),
        ],
      ),
    );
  }
}