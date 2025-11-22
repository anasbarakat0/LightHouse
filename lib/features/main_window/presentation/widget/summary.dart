import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/main_window/presentation/widget/pie_chart.dart';
import 'package:lighthouse/features/main_window/presentation/widget/summary_details.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/main_window/presentation/widget/task_display_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lighthouse/core/utils/task_notifier.dart';

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({super.key});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  late int visits;
  late int onGround;
  late int capacity;
  late bool language;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    onGround = memory.get<SharedPreferences>().getInt("onGround") ?? 0;
    visits = memory.get<SharedPreferences>().getInt("visits") ?? 0;
    capacity = memory.get<SharedPreferences>().getInt("capacity") ?? 100;
    capacityNotifier.addListener(_onCapacityChanged);
    languageNotifier.addListener(_onLanguageChanged);
    activeSessionsNotifier.addListener(_onActiveSessionsChanged);
  }

  void _onCapacityChanged() {
    if (mounted) {
      setState(() {
        capacity = capacityNotifier.value;
      });
    }
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {
        language = languageNotifier.value;
      });
    }
  }

  void _onActiveSessionsChanged() {
    if (mounted) {
      setState(() {
        onGround = activeSessionsNotifier.value;
      });
    }
  }

  @override
  void dispose() {
    capacityNotifier.removeListener(_onCapacityChanged);
    languageNotifier.removeListener(_onLanguageChanged);
    activeSessionsNotifier.removeListener(_onActiveSessionsChanged);
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final prefs = memory<SharedPreferences>();
    final String? taskData = prefs.getString('tasks');

    if (taskData != null) {
      List<Map<String, dynamic>> allTasks =
          List<Map<String, dynamic>>.from(json.decode(taskData));

      taskNotifier.value =
          allTasks.where((task) => !(task['completed'] ?? true)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [navy, darkNavy],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Chart(
                      onGround: onGround,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'summary'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    SummaryDetails(
                      visits: visits,
                      onGround: onGround,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: const Divider(thickness: 0.5),
                    ),
                    ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: taskNotifier,
                      builder: (context, tasks, _) {
                        return tasks.isNotEmpty
                            ? Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Text(
                                    'Pending_Tasks'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: lightGrey,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = tasks[index];
                                      return TaskDisplayTile(
                                        title: task['title'] ?? "No Title",
                                        dateTime: task['dateTime'] ??
                                            DateTime.now().toIso8601String(),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Text(
                                "No_pending_tasks!".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              );
                      },
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
