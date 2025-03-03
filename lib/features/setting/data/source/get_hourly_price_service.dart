import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetHourlyPriceService extends Service {
  GetHourlyPriceService({required super.dio});

  Future<Response> getHourlyPriceService() async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/hourly-price",
        options: options(true),
      );
      print(154876);
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
