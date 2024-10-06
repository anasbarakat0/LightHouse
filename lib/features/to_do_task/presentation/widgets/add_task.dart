import 'package:flutter/material.dart';
import 'package:light_house/core/resources/colors.dart';
import 'package:light_house/features/to_do_task/data/models/ToDoTasksModel.dart';
import 'package:light_house/features/to_do_task/presentation/view/to_do_tasks.dart';
import 'package:light_house/features/to_do_task/presentation/widgets/date_format.dart';

Future<ToDoTasksModel?> addTask(BuildContext context) async {
  TextEditingController startingTimeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  ToDoTasksModel? result;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create Your Wallet'),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardBackgroundColor,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    hintText: 'Title',
                    prefixIcon: const Icon(
                      Icons.edit_document,
                      color: Colors.grey,
                      size: 21,
                    ),
                  ),
                ),
                TextField(
                  controller: startingTimeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardBackgroundColor,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    hintText: 'Date',
                    prefixIcon: const Icon(
                      Icons.edit_document,
                      color: Colors.grey,
                      size: 21,
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final selectedDateTime = await showDateTimePicker(context);
                    if (selectedDateTime != null) {
                      setState(() {
                        startingTimeController.text = selectedDateTime;
                      });
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        startingTimeController.text.isNotEmpty) {
                      result = ToDoTasksModel(
                          title: titleController.text,
                          dateTime: date,
                          status: "pending");
                      Navigator.of(context).pop(result);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                        ),
                      );
                    }
                  },
                  child: const Text("Add Task"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
  return result;
}
