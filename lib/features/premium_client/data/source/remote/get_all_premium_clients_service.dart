import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';

class GetAllPremiumClientsService extends Service {
  GetAllPremiumClientsService({required super.dio});

  Future<Response> getAllPremiumClientsService(int page, int size) async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/dashboard/users/all-users?page=$page&size=$size",
        options: options(true),
      );
      return response;
    } on DioException catch (e) {
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