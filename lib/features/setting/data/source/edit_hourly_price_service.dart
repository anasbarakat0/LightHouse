import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';

class EditHourlyPriceService extends Service {
  EditHourlyPriceService({required super.dio});

  Future<Response> editHourlyPrice(double hourlyPrice) async {
    try {
      response = await dio.put(
        "$baseUrl/api/v1/hourly-price?newHourlyPrice=$hourlyPrice",
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
