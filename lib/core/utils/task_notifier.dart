import 'package:flutter/material.dart';

ValueNotifier<List<Map<String, dynamic>>> taskNotifier = ValueNotifier([]);

final ValueNotifier<int> activeSessionsNotifier = ValueNotifier<int>(0);

final ValueNotifier<int> capacityNotifier = ValueNotifier<int>(0);

final ValueNotifier<bool> languageNotifier = ValueNotifier<bool>(false);