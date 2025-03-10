// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lighthouse/core/resources/colors.dart';

// ignore: must_be_immutable
class MyDropdownButtonFormField extends StatelessWidget {
  String? selectedValue;
  String labelText;
  ValueChanged<String?> onChanged;
  List<DropdownMenuItem<String>> items;
  final Color color;
  final Color color1;
  final Color? color2;

  MyDropdownButtonFormField({
    super.key,
    this.selectedValue,
    required this.labelText,
    required this.onChanged,
    required this.items,
    this.color = const Color.fromRGBO(238, 238, 238, 1),
    this.color1 = Colors.grey,
    this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16.0), // Add spacing between fields
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: Theme.of(context).textTheme.labelSmall,
          
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(
                color:color2?? darkNavy, width: 2.0), // Border when focused
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(
                color: color1, width: 1.0), // Border when not focused
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          fillColor: color,//Background color of the dropdown field
          filled: true, // Enable the background fill
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
