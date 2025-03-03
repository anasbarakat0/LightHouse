import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class StartPremiumSessionService extends Service {
  StartPremiumSessionService({required super.dio});

  Future<Response> startPremiumSessionService(String id) async {
    try {
      response = await dio.post(
      "$baseUrl/api/v1/sessions/new-premium-session",
      options: options(true),
      data: {"userId": id},
    );
    return response;
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
