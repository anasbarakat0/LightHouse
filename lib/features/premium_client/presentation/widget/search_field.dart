// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:lighthouse/core/resources/colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;

  const SearchField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final hasQuery = controller.text.trim().isNotEmpty;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText ?? 'search_by_client_name'.tr(),
        hintStyle: const TextStyle(
          color: grey,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: grey,
          size: 22,
        ),
        suffixIcon: hasQuery
            ? IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: grey,
                  size: 20,
                ),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                  focusNode?.requestFocus();
                },
                splashRadius: 20,
              )
            : null,
        filled: true,
        fillColor: lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: yellow,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: yellow,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      style: const TextStyle(
        color: navy,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
