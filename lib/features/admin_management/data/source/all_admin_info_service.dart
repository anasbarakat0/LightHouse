import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';

class AllAdminInfoService extends Service {
  AllAdminInfoService({required super.dio});

  Future<Response> allAdminInfoService(int page, int size) async {
    try {
// final result = await Isolate.run(() async {
      response = await dio.get(
        "$baseUrl/api/v1/dashboard/admins/all-admins?page=$page&size=$size",
        options: getOptions(auth: true),
      );

      return response;
// });
//       return result;
    } on DioException catch (e) {
      if (e.response!.data['status'] == 403) {
        throw Forbidden();
      } else {
        rethrow;
      }
    }
  }
}
