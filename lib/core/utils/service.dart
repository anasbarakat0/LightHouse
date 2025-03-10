// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  Dio dio;
  late Response response;
  Service({
    required this.dio,
  });

  options(bool auth) {
    Options options;
    if (auth) {
      print(memory.get<SharedPreferences>().getString("token"));
      options = Options(
        headers: {
          'Accept': '*/*',
          'Authorization':
              'Bearer  ${memory.get<SharedPreferences>().getString("token")} ',
        },
      );
      //${memory.get<SharedPreferences>().getString("token")}
      return options;
    } else {
      options = Options(
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
      );
    }
  }
}
