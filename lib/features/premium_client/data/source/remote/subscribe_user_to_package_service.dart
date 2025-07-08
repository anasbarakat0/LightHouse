import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';

class SubscribeUserToPackageService extends Service {
  SubscribeUserToPackageService({required super.dio});

  Future<Response> subscribeUserToPackage(String packageId, String userId) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.post(
        "$baseUrl/api/v1/user-packages/$packageId?userId=$userId",
        options: getOptions(auth: true),
      );
      return response;
// });
//       return result;
    } on DioException catch (e) {
      print("DioException in subscribeUserToPackage");
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
