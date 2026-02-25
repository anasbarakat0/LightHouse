import 'package:flutter/material.dart';

/// Responsive: موبايل فقط أو PC (بدون وضع تابلت منفصل).
class Responsive {
  static const double _breakpoint = 850;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _breakpoint;

  /// لا يُستخدم وضع تابلت؛ التابلت يعامل كـ PC.
  static bool isTablet(BuildContext context) => false;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _breakpoint;
}
