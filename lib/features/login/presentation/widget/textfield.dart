import 'package:flutter/material.dart';
import 'package:lighthouse_/core/resources/colors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  bool? dark;

   MyTextField({
    required this.controller,
    this.label,
    this.hint,
    this.dark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 202, 202, 202),
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: orange,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        filled: false,
        fillColor: Colors.grey.shade800,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 23,
          horizontal: 40,
        ),

        // Border when the TextField is not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 202, 202, 202),
            width: 1.5,
          ),
        ),

        // Border when the TextField is focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: orange,
            width: 1,
          ),
        ),
      ),
      style:  TextStyle(
        color: dark??false ? navy: Colors.white,
        fontSize: 16,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
