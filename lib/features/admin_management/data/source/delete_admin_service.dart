import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';

class DeleteAdminService extends Service {
  DeleteAdminService({required super.dio});

  Future<Response> deleteAdminService(String id) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.delete("$baseUrl/api/v1/dashboard/admins/$id",
          options: getOptions(auth: true));
      return response;
// });
//       return result;
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
