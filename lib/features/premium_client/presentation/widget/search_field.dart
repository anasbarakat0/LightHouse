// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lighthouse/core/resources/colors.dart';

// ignore: must_be_immutable
class SearchField extends StatelessWidget {
  TextEditingController controller;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;
  SearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: TextField(
        controller: controller,
         textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          suffixIcon:  Icon(
            Icons.search,
            color: darkNavy,
          ),
          filled: true,
          fillColor: navy,
          labelText: "Search",
          labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
      
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: orange, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusColor: darkNavy,
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: darkNavy),
            borderRadius: BorderRadius.circular(12.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
