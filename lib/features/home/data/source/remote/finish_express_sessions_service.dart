import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

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
