import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lighthouse/core/utils/task_notifier.dart';

class LanguageDropdownSwitcher extends StatelessWidget {
  const LanguageDropdownSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;

    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<Locale>(
        borderRadius: BorderRadius.circular(12),
        value: currentLocale,
        icon: const Padding(
          padding: EdgeInsetsDirectional.only(end: 8),
          child: Icon(
            Icons.translate,
            color: Colors.blue,
            size: 20,
          ),
        ),
        focusColor: Colors.transparent,
        dropdownColor: const Color(0xFF1A2F4A),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            languageNotifier.value = !languageNotifier.value;
            context.setLocale(newLocale);
          }
        },
        items: [
          DropdownMenuItem(
            value: const Locale('en'),
            child: Text(
              'english'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DropdownMenuItem(
            value: const Locale('ar'),
            child: Text(
              'arabic'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

