import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
import 'package:lighthouse/features/premium_client/data/models/update_premium_client_model.dart';

class UpdatePremiumClientService extends Service {
  UpdatePremiumClientService({required super.dio});

  Future<Response> updatePremiumClientService(
      String userId, UpdatePremiumClientModel client) async {
    try {
      response = await dio.put(
        "$baseUrl/api/v1/dashboard/users/$userId",
        options: getOptions(auth: true),
        data: client.toMap(),
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

