import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt storage = GetIt.instance;

setUp() async {
  storage.registerSingleton(
    await SharedPreferences.getInstance(),
  );
}