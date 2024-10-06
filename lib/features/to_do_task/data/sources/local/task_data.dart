import 'package:hive_flutter/hive_flutter.dart';

class TasksData {
  // List<ToDoTasksModel> ToDoTasks = <ToDoTasksModel>[
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "In progress",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "Completed",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "In progress",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "pending",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "Completed",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "In progress",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "pending",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "Completed",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "In progress",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "pending",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "Completed",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "In progress",
  //   ),
  //   ToDoTasksModel(
  //     title: "title",
  //     dateTime: DateTime.now(),
  //     status: "pending",
  //   ),
  // ];

  final tasks = Hive.box("tasks");
  final length = Hive.box("length");

  void addTask(int key, String value) {
    print("addTask");
    if (length.get(0) == null) {
      print("if");
      tasks.put(key, value);
      length.put(0, 1);
      print(length.get(0));
    } else {
      print("else");
      tasks.put(key, value);
      length.put(0, length.get(0) + 1);
      print(length.get(0));
    }
  }

  String getTasks(int key) {
    print("getTask");
    print(tasks.get(key));
    return tasks.get(key);
  }

  void deleteTask(int key) {
    print("deleteTask");
    tasks.delete(key);
    length.put(0, length.get(0) - 1);
    print(length.get(0));
  }
}
