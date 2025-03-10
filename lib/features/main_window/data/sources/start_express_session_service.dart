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
      response = await dio.post(
        "$baseUrl/api/v1/sessions/new-express-session",
        options: options(true),
        data: {"fullName": fullName},
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
