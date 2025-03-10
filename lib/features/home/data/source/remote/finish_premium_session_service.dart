import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinishPremiumSessionService extends Service {
  FinishPremiumSessionService({required super.dio});

  Future<Response> finishPremiumSessionService(String id) async {
    try {
      response = await dio.put("$baseUrl/api/v1/sessions/premium/$id",
          options: options(true));

          final prefs = memory.get<SharedPreferences>();

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
