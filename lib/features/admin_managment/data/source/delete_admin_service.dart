import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';

class DeleteAdminService extends Service {
  DeleteAdminService({required super.dio});

  Future<Response> deleteAdminService(String id) async {
    try {
      response = await dio.delete("$baseUrl/api/v1/dashboard/admins/$id",
          options: options(true));
      return response;
    } on DioException catch (e) {
      if (e.response!.data["status"] == "BAD_REQUEST") {
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data["status"] == 403) {
        throw Forbidden();
      } else {
        rethrow;
      }
    }
  }
}
