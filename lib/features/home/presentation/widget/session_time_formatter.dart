import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String formatPremiumSessionTime(BuildContext context, String rawTime) {
  if (rawTime.trim().isEmpty) return rawTime;

  final normalizedTime = rawTime.split('.').first.trim();
  final locale = context.locale.toString();
  const outputPattern = 'hh:mm a';

  for (final inputPattern in const ['HH:mm:ss', 'HH:mm']) {
    try {
      final parsedTime = DateFormat(inputPattern).parseStrict(normalizedTime);
      final adjustedTime = parsedTime.add(const Duration(hours: 3));
      return DateFormat(outputPattern, locale).format(adjustedTime);
    } catch (_) {
      // Try the next supported input pattern.
    }
  }

  try {
    final parsedDateTime =
        DateTime.parse(rawTime).add(const Duration(hours: 3));
    return DateFormat(outputPattern, locale).format(parsedDateTime);
  } catch (_) {
    return rawTime;
  }
}
