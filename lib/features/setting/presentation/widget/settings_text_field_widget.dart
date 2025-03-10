// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lighthouse/core/resources/colors.dart';

class SettingsTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget suffix;
  final void Function(String)? onSubmitted;
  final bool readOnly;
  const SettingsTextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.suffix,
    this.onSubmitted,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: orange),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: controller,
        onSubmitted: onSubmitted,
        readOnly: readOnly,
        decoration: InputDecoration(
          label: Text(
            label.tr(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
          suffix: Padding(
            padding: const EdgeInsetsDirectional.only(end: 5,bottom: 2),
            child: suffix,
          ),
        ),
      ),
    );
  }
}
