import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetDashboardRevenueChartService extends Service {
  GetDashboardRevenueChartService({required super.dio});

  Future<Response> getDashboardRevenueChartService({
    String? period,
    String? from,
    String? to,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (period != null) queryParams['period'] = period;
      if (from != null) queryParams['from'] = from;
      if (to != null) queryParams['to'] = to;

      response = await dio.get(
        "$baseUrl/api/v1/statistics/revenue/chart",
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

