// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:lighthouse_/core/resources/colors.dart';

class SettingsTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmitted;
  final bool readOnly;
  const SettingsTextFieldWidget({
    super.key,
    required this.controller,
    this.onSubmitted,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: primaryColor,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: controller,
        onSubmitted: onSubmitted,
        readOnly: readOnly,
        decoration: InputDecoration(
          label: Text(
            "Hourly_Price".tr(),
            style: const TextStyle(color: primaryColor),
          ),
          suffix: Padding(
            padding: const EdgeInsetsDirectional.only(end: 5,bottom: 2),
            child: SvgPicture.asset(
              "assets/svg/hourly_price.svg",
              width: 28,
              height: 28,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
