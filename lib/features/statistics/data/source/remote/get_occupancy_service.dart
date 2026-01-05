import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetOccupancyService extends Service {
  GetOccupancyService({required super.dio});

  Future<Response> getOccupancyService() async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/statistics/occupancy",
        options: getOptions(auth: false), // لا يحتاج authentication
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


