import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';

class AdminByIdService extends Service {
  AdminByIdService({required super.dio});

  Future<Response> adminByIdService(String id) async {
    try {
      print(6);
      response = await dio.get(
          "$baseUrl/api/v1/dashboard/admins/admin-by-id/$id",
          options: options(true));
          print("7 response");
      return response;
    } on DioException catch (e) {
          print("7 error");
      if (e.response!.data["status"] == "BAD_REQUEST") {
        print("54137");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        print("54154");
        throw Forbidden();
      } else {
        print("97245");
        rethrow;
      }
    }
  }
}
