import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';

class EditHourlyPriceService extends Service {
  EditHourlyPriceService({required super.dio});

  Future<Response> editHourlyPrice(double hourlyPrice) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.put(
        "$baseUrl/api/v1/hourly-price?newHourlyPrice=$hourlyPrice",
        options: getOptions(auth: true),
      );
      return response;
// });
//       return result;
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
