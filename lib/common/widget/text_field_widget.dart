// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lighthouse_/core/resources/colors.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  TextEditingController? controller;
  final String labelText;
  final bool isPassword;
  final bool? readOnly;
  List<TextInputFormatter>? inputFormatters;
  void Function()? onTap;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;
  MyTextField({
    Key? key,
    this.controller,
    required this.labelText,
    required this.isPassword,
    this.readOnly,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16.0), // Add spacing between fields
      child: TextField(
        controller: controller,
        inputFormatters: inputFormatters,
        obscureText: isPassword, // Toggle for password field
        readOnly: readOnly ?? false,
        onTap: onTap,
        onSubmitted: onSubmitted,
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
