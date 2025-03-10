import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/core/utils/task_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetAllActiveSessionsService extends Service {
  GetAllActiveSessionsService({required super.dio});

  Future<Response> getAllActiveSessionsService() async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/sessions/active-sessions",
        options: options(true),
      );


      final prefs = memory.get<SharedPreferences>();
      
      int onGround =
          (response.data["body"]["activePremiumSessions"].length ?? 0) +
              (response.data["body"]["activeExpressSessions"].length ?? 0);
      prefs.setInt("onGround", onGround);
      activeSessionsNotifier.value = onGround;

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
