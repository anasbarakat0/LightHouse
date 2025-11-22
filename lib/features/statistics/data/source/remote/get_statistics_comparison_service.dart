import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetStatisticsComparisonService extends Service {
  GetStatisticsComparisonService({required super.dio});

  Future<Response> getStatisticsComparisonService({
    required String currentFrom,
    required String currentTo,
    required String previousFrom,
    required String previousTo,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'currentFrom': currentFrom,
        'currentTo': currentTo,
        'previousFrom': previousFrom,
        'previousTo': previousTo,
      };

      response = await dio.get(
        "$baseUrl/api/v1/statistics/comparison",
        queryParameters: queryParams,
        options: getOptions(auth: true),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
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

