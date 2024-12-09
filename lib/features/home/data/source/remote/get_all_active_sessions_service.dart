import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';

class GetAllActiveSessionsService extends Service {
  GetAllActiveSessionsService({required super.dio});

  Future<Response> getAllActiveSessionsService() async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/sessions/active-sessions",
        options: options(true),
      );
      return response;
   } on DioException catch (e) {
      print("GetAllActiveSessionsService  DioException");
      if (e.response!.data["status"] == "BAD_REQUEST") {
        print("GetAllActiveSessionsService  BAD_REQUEST");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        print("GetAllActiveSessionsService  Forbidden");
        throw Forbidden();
      } else {
        print("GetAllActiveSessionsService  else");
        rethrow;
      }
    }
  }
}
