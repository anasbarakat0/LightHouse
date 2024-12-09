import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';

class FinishExpressSessionsService extends Service {
  FinishExpressSessionsService({required super.dio});

  Future<Response> finishExpressSessionsService(String id) async {
    try {
      response = await dio.put(
        "$baseUrl/api/v1/sessions/express/$id",
        options: options(true),
      );
      return response;
     } on DioException catch (e) {
      print("FinishExpressSessionsService  DioException");
      if (e.response!.data["status"] == "BAD_REQUEST") {
        print("FinishExpressSessionsService  BAD_REQUEST");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        print("FinishExpressSessionsService  Forbidden");
        throw Forbidden();
      } else {
        print("FinishExpressSessionsService  else");
        rethrow;
      }
    }
  }
}
