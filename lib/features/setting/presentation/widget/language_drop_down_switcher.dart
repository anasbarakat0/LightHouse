import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/task_notifier.dart';

class LanguageDropdownSwitcher extends StatelessWidget {
  const LanguageDropdownSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;

    return Container(
      height: 69,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(width: 1, color: yellow),
      ),
      padding: const EdgeInsets.all(8),
      child: DropdownButtonFormField<Locale>(
        borderRadius: BorderRadius.circular(10),
        value: currentLocale,
        icon: const Padding(
          padding: EdgeInsetsDirectional.only(end: 8),
          child: Icon(
            Icons.translate,
            color: orange,
          ),
        ),
        focusColor: const Color.fromRGBO(0, 0, 0, 0),
        dropdownColor: orange,
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
          DropdownMenuItem(
            value: const Locale('ar'),
            child: Text(
              'arabic'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
