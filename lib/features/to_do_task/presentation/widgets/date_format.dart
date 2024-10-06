import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:light_house/features/to_do_task/presentation/view/to_do_tasks.dart';

Future<String?> showDateTimePicker(BuildContext context) async {
  final now = DateTime.now();

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: now,
    lastDate: DateTime(2101),
  );
  if (pickedDate == null) {
    return null;
  }

  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime == null) {
    return null;
  }

  final chosenDateTime = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
  date = chosenDateTime;
  return formatDateTime(chosenDateTime, now);
}

String formatDateTime(DateTime chosenDateTime, DateTime now) {
  if (isSameDay(chosenDateTime, now)) {
    return "Today, ${formatTime(chosenDateTime)}";
  } else if (isSameDay(chosenDateTime, now.add(const Duration(days: 1)))) {
    return "Tomorrow, ${formatTime(chosenDateTime)}";
  } else if ((chosenDateTime.day + chosenDateTime.month * 30) -
          (now.day + now.month * 30) <
      7) {
    final String day = DateFormat('E').format(chosenDateTime);
    return "$day, ${formatTime(chosenDateTime)}";
  } else {
    final String day = DateFormat('d/M').format(chosenDateTime);
    return "$day, ${formatTime(chosenDateTime)}";
  }
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String formatTime(DateTime dateTime) {
  final hour = dateTime.hour;
  final minute = dateTime.minute;
  final period = hour >= 12 ? 'PM' : 'AM';
  final formattedHour = hour % 12 == 0 ? 12 : hour % 12;
  return "$formattedHour${minute == 0 ? '' : ':${minute.toString().padLeft(2, '0')}'}$period";
}
