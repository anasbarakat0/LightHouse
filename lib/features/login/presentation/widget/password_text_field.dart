import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

class MyPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool? dark;

   const MyPasswordTextField({
    required this.controller,
    this.label,
    this.hint,
    this.dark,
    super.key,
  });

  @override
  _MyPasswordTextFieldState createState() => _MyPasswordTextFieldState();
}

class _MyPasswordTextFieldState extends State<MyPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
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
        ), // Padding inside the text field

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

        // Toggle visibility of password
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey.shade600,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      style:  TextStyle(
        color:widget.dark??false? navy: Colors.white,
        fontSize: 16,
      ),
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
