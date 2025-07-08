import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/common/widget/header.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/tasks/presentation/widget/task_tile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lighthouse/core/utils/task_notifier.dart';

class ToDoTasks extends StatefulWidget {
  const ToDoTasks({super.key});

  @override
  State<ToDoTasks> createState() => _ToDoTasksState();
}

class _ToDoTasksState extends State<ToDoTasks>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> tasks = [];
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDateTime;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _loadTasks();
  }

  void _loadTasks() {
  final prefs = memory<SharedPreferences>();
  final String? taskData = prefs.getString('tasks');
  final String? userId = prefs.getString("userId");

  if (taskData != null && userId != null) {
    setState(() {
      tasks = List<Map<String, dynamic>>.from(json.decode(taskData))
          .where((task) => task['userId'] == userId)
          .toList();
    });
    _sortTasks();
    _controller.forward();
  }
}

  void _saveTasks() {
    final prefs = memory<SharedPreferences>();
    prefs.setString('tasks', json.encode(tasks));

    taskNotifier.value =
        List.from(tasks.where((task) => !(task['completed'] ?? true)));
  }

  void _addTask(String title) {
    if (title.isNotEmpty && _selectedDateTime != null) {
      setState(() {
        tasks.add({
          'userId': memory.get<SharedPreferences>().getString("userId"),
          'title': title,
          'completed': false,
          'dateTime': _selectedDateTime!.toIso8601String(),
        });
      });
      _taskController.clear();
      _selectedDateTime = null;
      _sortTasks();
      _saveTasks();
      _controller.forward(from: 0);
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['completed'] = !tasks[index]['completed'];
      _sortTasks();
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _sortTasks() {
    tasks.sort((a, b) {
      DateTime aDate = DateTime.parse(a['dateTime']);
      DateTime bDate = DateTime.parse(b['dateTime']);
      bool aCompleted = a['completed'];
      bool bCompleted = b['completed'];

      if (aCompleted && !bCompleted) return 1;
      if (!aCompleted && bCompleted) return -1;

      return aDate.compareTo(bDate);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          HeaderWidget(title: "to_do_task".tr()),
          const SizedBox(height: 25),
          if (Responsive.isDesktop(context))
            Text(
              "to_do_task".tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          if (Responsive.isDesktop(context)) const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: darkNavy.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(2, 6)),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "New_Task".tr(),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _pickDateTime,
                      icon: Icon(Icons.calendar_today, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => _addTask(_taskController.text),
                      icon: Icon(Icons.add, color: orange, size: 28),
                    ),
                  ],
                ),
                if (_selectedDateTime != null)
                  Text(
                    "Scheduled: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: yellow),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      "No_pending_tasks!".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: grey),
                    ),
                  )
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return AnimatedTaskTile(
                          title: task['title'],
                          dateTime: task['dateTime'],
                          completed: task['completed'],
                          onToggle: () => _toggleTaskCompletion(index),
                          onDelete: () => _deleteTask(index),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
