import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:light_house/core/utils/responsive.dart';
import 'package:light_house/features/to_do_task/data/models/ToDoTasksModel.dart';
import 'package:light_house/features/to_do_task/data/sources/local/task_data.dart';
import 'package:light_house/features/to_do_task/presentation/widgets/add_task.dart';
import 'package:light_house/features/to_do_task/presentation/widgets/date_format.dart';
import 'package:light_house/features/mian_screen/presentation/widget/custom_cart.dart';
import 'package:light_house/features/mian_screen/presentation/widget/header.dart';

class ToDoTasks extends StatefulWidget {
  const ToDoTasks({super.key});

  @override
  State<ToDoTasks> createState() => _ToDoTasksState();
}

late DateTime date;

class _ToDoTasksState extends State<ToDoTasks> {
  TextEditingController startingTimeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  late TasksData data;
  late List<ToDoTasksModel> tasks;

  @override
  void initState() {
    data = TasksData();
    tasks = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 18),
                const HeaderWidget(),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  "To Do Tasks",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                ValueListenableBuilder(
                  valueListenable:
                      Hive.box<ToDoTasksModel>('tasks').listenable(),
                  builder: (context, Box<ToDoTasksModel> tasksBox, _) {
                    if (tasksBox.isEmpty) {
                      return const Center(
                        child: Text('No tasks yet!'),
                      );
                    } else {
                      return SizedBox(
                        height: tasksBox.length * 73,
                        child: ListView.builder(
                          itemCount: tasksBox.length,
                          itemBuilder: (context, index) {
                            // if (condition) {

                            // } else {

                            // }

                            ToDoTasksModel task = tasksBox.getAt(index)!;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 16),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor:
                                          const Color.fromRGBO(211, 47, 47, 1),
                                      label: "Delete",
                                      icon: Icons.delete,
                                      onPressed: (T) {
                                        setState(() {
                                          data.deleteTask(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                child: CustomCard(
                                  color: Colors.black,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${index + 1}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.title,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  formatDateTime(
                                                    task.dateTime,
                                                    DateTime.now(),
                                                  ),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: task.status == "pending"
                                                ? Colors.white
                                                : task.status == "In progress"
                                                    ? Colors.amber[200]
                                                    : Colors.greenAccent[400],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              task.status,
                                              style: TextStyle(
                                                color: task.status == "pending"
                                                    ? Colors.grey[900]
                                                    : task.status ==
                                                            "In progress"
                                                        ? Colors.yellow[900]
                                                        : Colors.green[900],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: Responsive.isMobile(context) ? 20 : null,
            right: Responsive.isMobile(context) ? null : 20,
            child: Responsive.isMobile(context)
                ? FloatingActionButton(
                    onPressed: () async {
                      ToDoTasksModel? newTask = await addTask(context);
                      if (newTask != null) {
                        setState(() {
                          data.addTask(data.length.get(0) ?? 0, "newTask");
                          // data.ToDoTasks.sort(
                          //     (a, b) => a.dateTime.compareTo(b.dateTime));
                        });
                      }
                    },
                    child: const Icon(Icons.add_task),
                  )
                : FloatingActionButton.extended(
                    onPressed: () async {
                      ToDoTasksModel? newTask = await addTask(context);
                      if (newTask != null) {
                        setState(() {
                          data.addTask(data.length.get(0) ?? 0, "newTask");
                          // data.ToDoTasks.sort(
                          //     (a, b) => a.dateTime.compareTo(b.dateTime));
                        });
                      }
                    },
                    label: const Text("Add Task"),
                    icon: const Icon(Icons.add_task),
                  ),
          ),
        ],
      ),
    );
  }
}
