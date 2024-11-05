import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';

class AllAdminInfoService extends Service {
  AllAdminInfoService({required super.dio});

  Future<Response> allAdminInfoService(int page, int size) async {
    try {
      print("run");
      response = await dio.get(
        "$baseUrl/api/v1/dashboard/admins/all-admins?page=$page&size=$size",
        options: options(true),
      );
      print("service: all_admin_info_service.dart");
      return response;
    } on DioException catch (e) {
      if (e.response!.data['status'] == 403) {
        throw Forbidden();
      } else {
        rethrow;
      }
    }
  }
}
