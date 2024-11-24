import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';

class StartExpressSessionService extends Service {
  StartExpressSessionService({required super.dio});

  Future<Response> startExpressSessionService(String fullName) async {
    try {
      response = await dio.post(
        "$baseUrl/api/v1/sessions/new-express-session",
        options: options(true),
        data: {"fullName": fullName},
      );
      print("StartExpressSessionService  return response");
      return response;
    } on DioException catch (e) {
      print("StartExpressSessionService  DioException");
      if (e.response!.data["status"] == "BAD_REQUEST") {
        print("StartExpressSessionService  BAD_REQUEST");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        print("StartExpressSessionService  Forbidden");
        throw Forbidden();
      } else {
        print("StartExpressSessionService  else");
        rethrow;
      }
    }
  }
}
