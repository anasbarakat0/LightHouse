import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

// ignore: must_be_immutable
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
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        
        labelText: label,
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: grey),
        labelStyle: Theme.of(context).textTheme.titleSmall,
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
      style:  Theme.of(context).textTheme.bodyMedium?.copyWith(color: dark??false ? navy: Colors.white),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
