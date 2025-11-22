// import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartExpressSessionService extends Service {
  StartExpressSessionService({required super.dio});

  Future<Response> startExpressSessionService(String fullName) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.post(
        "$baseUrl/api/v1/sessions/new-express-session",
        options: getOptions(auth: true),
        data: {"fullName": fullName},
      );

      final prefs = memory.get<SharedPreferences>();
      final String? memoryDate = prefs.getString("memoryDate");
      final String? dateString = response.data["localDateTime"]?.toString();
      DateTime currentDateTime =
          DateTime.tryParse(dateString ?? "") ?? DateTime.now();

      final DateTime? storedDate =
          memoryDate != null ? DateTime.tryParse(memoryDate) : null;
      if (storedDate != null &&
          storedDate.year == currentDateTime.year &&
          storedDate.month == currentDateTime.month &&
          storedDate.day == currentDateTime.day) {
        final int visits = prefs.getInt("visits") ?? 0;
        prefs.setInt("visits", visits + 1);
      } else {
        prefs.setInt("visits", 1);
        prefs.setString("memoryDate", currentDateTime.toIso8601String());
      }

      return response;
// });
//       return result;
    } on DioException catch (e) {
      if (e.response!.data["status"] == "BAD_REQUEST") {
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        throw Forbidden();
      } else {
        rethrow;
      }
    }
  }
}
