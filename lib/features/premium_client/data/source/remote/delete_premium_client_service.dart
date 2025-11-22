import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class DeletePremiumClientService extends Service {
  DeletePremiumClientService({required super.dio});

  Future<Response> deletePremiumClientService(String userId) async {
    try {
      response = await dio.delete(
        "$baseUrl/api/v1/dashboard/users/$userId",
        options: getOptions(auth: true),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data["status"] == "BAD_REQUEST") {
          throw BAD_REQUEST.fromMap(e.response!.data);
        } else if (e.response!.data['status'] == 403 ||
            e.response!.statusCode == 403) {
          throw Forbidden();
        }
      }
      rethrow;
    }
  }
}

