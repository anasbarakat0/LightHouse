import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetStatisticsSessionsService extends Service {
  GetStatisticsSessionsService({required super.dio});

  Future<Response> getStatisticsSessionsService({
    String? from,
    String? to,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (from != null && from.isNotEmpty) {
        queryParams['from'] = from;
      }
      if (to != null && to.isNotEmpty) {
        queryParams['to'] = to;
      }

      response = await dio.get(
        "$baseUrl/api/v1/statistics/sessions",
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
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

