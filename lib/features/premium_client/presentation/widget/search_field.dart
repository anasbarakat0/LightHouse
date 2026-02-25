// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lighthouse/core/resources/colors.dart';

// ignore: must_be_immutable
class SearchField extends StatelessWidget {
  TextEditingController controller;
  FocusNode? focusNode;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;
  SearchField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.search,
            color: grey,
          ),
          filled: true,
          fillColor: lightGrey,
          labelText: "Search",
          labelStyle: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: navy),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: yellow, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusColor: darkNavy,
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: navy),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
