
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

class TaskDisplayTile extends StatelessWidget {
  final String title;
  final String dateTime;

  const TaskDisplayTile({
    super.key,
    required this.title,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime taskDate = DateTime.parse(dateTime);
    final String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(taskDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: darkNavy,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: darkNavy),
      ),
      child: ListTile(
        leading: const Icon(Icons.pending_actions, color: orange),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white
                          ),
        ),
        subtitle: Text(
          "Due: $formattedDate",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: grey
                          ),
        ),
      ),
    );
  }
}
