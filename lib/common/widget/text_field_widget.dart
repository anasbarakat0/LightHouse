// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lighthouse_/core/resources/colors.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final bool? readOnly;
  void Function()? onTap;
  void Function(String)? onChanged;
  MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.isPassword,
    this.readOnly,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16.0), // Add spacing between fields
      child: TextField(
        controller: controller,
        obscureText: isPassword, // Toggle for password field
        readOnly: readOnly ?? false,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(
            color: backgroundColor), // Set text color to backgroundColor
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: backgroundColor), // Label color
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: backgroundColor, width: 2.0), // Border when focused
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.grey, width: 1.0), // Border when not focused
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          fillColor: Colors.grey[200], // Background color of the text field
          filled: true, // Enable the background fill
        ),
      ),
    );
  }
}

// widget MyTextField(TextEditingController controller, String labelText,
//     {bool isPassword = false}) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 16.0), // Add spacing between fields
//     child: TextField(
//       controller: controller,
//       obscureText: isPassword, // Toggle for password field
//       style: const TextStyle(
//           color: backgroundColor), // Set text color to backgroundColor
//       decoration: InputDecoration(
//         labelText: labelText,
//         labelStyle: const TextStyle(color: backgroundColor), // Label color
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: backgroundColor, width: 2.0), // Border when focused
//           borderRadius: BorderRadius.circular(12.0), // Rounded corners
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Colors.grey, width: 1.0), // Border when not focused
//           borderRadius: BorderRadius.circular(12.0), // Rounded corners
//         ),
//         fillColor: Colors.grey[200], // Background color of the text field
//         filled: true, // Enable the background fill
//       ),
//     ),
//   );
// }
