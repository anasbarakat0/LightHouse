import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String formatPremiumSessionDuration(BuildContext context, double hours) {
  if (hours.isNaN || hours.isInfinite) return hours.toString();

  final totalMinutes = (hours * 60).round();
  final hoursPart = totalMinutes ~/ 60;
  final minutesPart = totalMinutes % 60;
  final isArabic = context.locale.languageCode.toLowerCase() == 'ar';

  if (isArabic) {
    if (hoursPart > 0 && minutesPart > 0) {
      return '$hoursPart ${hoursPart == 1 ? 'ساعة' : 'ساعات'} و $minutesPart دقيقة';
    }
    if (hoursPart > 0) {
      return '$hoursPart ${hoursPart == 1 ? 'ساعة' : 'ساعات'}';
    }
    return '$minutesPart دقيقة';
  }

  if (hoursPart > 0 && minutesPart > 0) {
    return '$hoursPart ${hoursPart == 1 ? 'hr' : 'hrs'} $minutesPart min';
  }
  if (hoursPart > 0) {
    return '$hoursPart ${hoursPart == 1 ? 'hr' : 'hrs'}';
  }
  return '$minutesPart min';
}
