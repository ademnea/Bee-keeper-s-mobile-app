import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  final IconData icon;
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon; // Add this parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,

    required this.icon,
    this.obscureText = false,
    this.suffixIcon, // Add this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,

        fillColor: Colors.brown.shade100,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(icon),
        ),
        suffixIcon: suffixIcon, // Add this line
      ),
      style: const TextStyle(
        height: 1.5,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}

