
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

class AnimatedTaskTile extends StatelessWidget {
  final String title;
  final String dateTime;
  final bool completed;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const AnimatedTaskTile({
    super.key,
    required this.title,
    required this.dateTime,
    required this.completed,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(dateTime));
    bool past = DateTime.parse(dateTime).isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: darkNavy,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  offset: const Offset(3, 6))
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: ListTile(
            leading: IconButton(
              icon: Icon(
                  completed ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: completed ? orange : grey),
              onPressed: onToggle,
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                decoration: completed ? TextDecoration.lineThrough : null,
                color: completed ? Colors.green : past? Colors.red: Colors.white,

              ),
            ),
            subtitle: Text("Scheduled: $formattedDate",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: yellow),),
            trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red[800]), onPressed: onDelete),
          ),
        ),
      ),
    );
  }
}
