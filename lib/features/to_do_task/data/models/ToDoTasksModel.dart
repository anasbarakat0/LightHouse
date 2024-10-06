import 'package:hive/hive.dart';

part 'ToDoTasksModel.g.dart';

@HiveType(typeId: 0)
class ToDoTasksModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final DateTime dateTime;

  @HiveField(2)
  final String status;

  ToDoTasksModel({
    required this.title,
    required this.dateTime,
    required this.status,
  });
}
