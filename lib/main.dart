import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:light_house/core/resources/colors.dart';
import 'package:light_house/features/mian_screen/presentation/view/mian_screen.dart';
// import 'package:light_house/features/to_do_task/data/models/ToDoTasksModel.dart'
//     hide ToDoTasksModelAdapter;
// import 'package:light_house/features/to_do_task/data/models/ToDoTasksModelAdapter.dart';
// import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final appDocumentDirectory = await getApplicationDocumentsDirectory();
  // await Hive.initFlutter(appDocumentDirectory.path);
  // Hive.registerAdapter(ToDoTasksModelAdapter());
  // await Hive.openBox<ToDoTasksModel>('tasks');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LightHouse",
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
