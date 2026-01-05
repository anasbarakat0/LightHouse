import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class UpdateCapacityService extends Service {
  UpdateCapacityService({required super.dio});

  Future<Response> updateCapacityService(int capacity) async {
    try {
      response = await dio.put(
        "$baseUrl/api/v1/statistics/capacity",
        queryParameters: {'capacity': capacity},
        options: getOptions(auth: true), // يحتاج authentication
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data["status"] == "BAD_REQUEST") {
          throw BAD_REQUEST.fromMap(e.response!.data);
        } else if (e.response!.data['status'] == 403 ||
            e.response!.statusCode == 403) {
          throw Forbidden();
        }
      }
      rethrow;
    }
  }
}


