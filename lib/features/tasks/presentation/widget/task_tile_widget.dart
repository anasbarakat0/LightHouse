import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
        DateFormat('MMM dd, yyyy • HH:mm').format(DateTime.parse(dateTime));
    final bool past = DateTime.parse(dateTime).isBefore(DateTime.now());
    final bool isOverdue = past && !completed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: completed
                  ? [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.05),
                    ]
                  : isOverdue
                      ? [
                          Colors.red.withOpacity(0.15),
                          Colors.red.withOpacity(0.05),
                        ]
                      : [
                          const Color(0xFF1A2F4A),
                          const Color(0xFF0F1E2E),
                        ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: completed
                  ? Colors.green.withOpacity(0.3)
                  : isOverdue
                      ? Colors.red.withOpacity(0.3)
                      : Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Checkbox
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: completed
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.green.withOpacity(0.8),
                                  Colors.green.withOpacity(0.6),
                                ],
                              )
                            : null,
                        color: completed ? null : Colors.transparent,
                        border: Border.all(
                          color: completed
                              ? Colors.green
                              : Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: completed
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),

                    // Task Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: completed
                                  ? Colors.greenAccent[400]
                                  : isOverdue
                                      ? Colors.redAccent[400]
                                      : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: completed
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationThickness: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: isOverdue
                                    ? Colors.redAccent[400]
                                    : Colors.white.withOpacity(0.6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: isOverdue
                                      ? Colors.redAccent[400]
                                      : Colors.white.withOpacity(0.6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  decoration: completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              if (isOverdue) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    "Overdue".tr(),
                                    style: TextStyle(
                                      color: Colors.redAccent[400],
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Delete Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.red.withOpacity(0.2),
                                Colors.red.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
