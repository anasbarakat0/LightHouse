import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetSessionsByUserIdService extends Service {
  GetSessionsByUserIdService({required super.dio});

  Future<Response> getSessionsByUserId(
      String userId, int page, int size) async {
    try {
      var response = await dio.get(
        "$baseUrl/api/v1/sessions/$userId?page=$page&size=$size&sort=date,desc&sort=startTime,desc",
        options: getOptions(auth: true),
      );

      return response;
    } on DioException catch (e) {
      if (e.response!.data["status"] == "BAD_REQUEST") {
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data["status"] == 403) {
        throw Forbidden();
      } else {
        rethrow;
      }
    }
  }
}
