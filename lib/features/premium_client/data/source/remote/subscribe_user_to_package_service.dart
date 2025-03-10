import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class SubscribeUserToPackageService extends Service {
  SubscribeUserToPackageService({required super.dio});

  Future<Response> subscribeUserToPackage(String packageId, String userId) async {
    try {
      // Assuming a POST request with no extra body payload.
      response = await dio.post(
        "$baseUrl/api/v1/user-packages/$packageId?userId=$userId",
        options: options(true),
      );
      return response;
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
