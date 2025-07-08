import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPremiumSessionService extends Service {
  StartPremiumSessionService({required super.dio});

  Future<Response> startPremiumSessionService(String id) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.post(
        "$baseUrl/api/v1/sessions/new-premium-session",
        options: getOptions(auth: true),
        data: {"userId": id},
      );

      final prefs = memory.get<SharedPreferences>();
      String? memoryDate = prefs.getString("memoryDate");
      String dateString = response.data["localDateTime"];
      DateTime currentDateTime = DateTime.parse(dateString);

      if (memoryDate != null) {
        DateTime storedDate = DateTime.parse(memoryDate);
        if (storedDate.year == currentDateTime.year &&
            storedDate.month == currentDateTime.month &&
            storedDate.day == currentDateTime.day) {
          // int onGround = prefs.getInt("onGround") ?? 0;
          // prefs.setInt("onGround", onGround + 1);
          int visits = prefs.getInt("visits") ?? 0;
          prefs.setInt("visits", visits + 1);
        } else {
          // prefs.setInt("onGround", 1);
          prefs.setInt("visits", 1);
          prefs.setString("memoryDate", dateString);
        }
      } else {
        // prefs.setInt("onGround", 1);
        prefs.setInt("visits", 1);
        prefs.setString("memoryDate", dateString);
      }

      return response;
// });
//       return result;
    } on DioException catch (e) {
      print("DioException StartPremiumSessionService");
      if (e.response!.data["status"] == "BAD_REQUEST") {
        print("BAD_REQUEST StartPremiumSessionService");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        print("Forbidden StartPremiumSessionService");
        throw Forbidden();
      } else {
        print("StartPremiumSessionService");
        rethrow;
      }
    }
  }
}
