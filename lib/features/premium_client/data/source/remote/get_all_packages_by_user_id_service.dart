import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';

class GetAllPackagesByUserIdService extends Service {
  GetAllPackagesByUserIdService({required super.dio});

  Future<Response> getAllPackagesByUserId(String userId, int page, int size) async {
    try {
      // final result = await Isolate.run(() async {
      var response = await dio.get(
        "$baseUrl/api/v1/user-packages/active/$userId?page=$page&size=$size",
        options: getOptions(auth: true),
      );
      return response;
// });
//       return result;
    } on DioException catch (e) {
      print("DioException in getAllPackagesByUserIdService");
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
