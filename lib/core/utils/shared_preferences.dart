import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt memory = GetIt.instance;

setUp() async {
  memory.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
}