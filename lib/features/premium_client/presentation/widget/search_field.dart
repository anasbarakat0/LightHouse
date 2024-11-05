// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lighthouse_/core/resources/colors.dart';

// ignore: must_be_immutable
class SearchField extends StatelessWidget {
  TextEditingController controller;
  SearchField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
       
        suffixIcon: const Icon(
          Icons.search,
          color: backgroundColor,
        ),
        filled: true,
        fillColor: cardBackgroundColor,
        labelText: "Search",
        labelStyle: const TextStyle(color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusColor: backgroundColor,
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: backgroundColor),
          borderRadius: BorderRadius.circular(12.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}
