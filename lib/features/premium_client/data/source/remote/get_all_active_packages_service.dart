import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetAllActivePackagesService extends Service {
  GetAllActivePackagesService({required super.dio});

  Future<Response> getAllActivePackages(int page, int size) async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/packages/active-packages?page=$page&size=$size",
        options: options(true),
      );
      return response;
    } on DioException catch (e) {
      print("DioException in getAllActivePackagesService");
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
