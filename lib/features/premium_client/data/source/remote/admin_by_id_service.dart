import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';

class AdminByIdService extends Service {
  AdminByIdService({required super.dio});

  Future<Response> adminByIdService(String id) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.get(
        "$baseUrl/api/v1/dashboard/admins/admin-by-id/$id",
        options: getOptions(auth: true),
      );
      print("7 response");
      return response;
// });
//       return result;
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
