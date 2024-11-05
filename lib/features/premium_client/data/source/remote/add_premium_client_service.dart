import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';
import 'package:lighthouse_/features/premium_client/data/models/premium_client_model.dart';

class AddPremiumClientService extends Service {
  AddPremiumClientService({required super.dio});

  Future<Response> addPremiumClientService(PremiumClient client) async {
    try {
      response = await dio.post(
        "$baseUrl/api/v1/dashboard/users/new-premium-user",
        options: options(true),
        data: client.toMap(),
      );
      return response;
    } on DioException catch (e) {
      if (e.response!.data["status"] == "BAD_REQUEST") {
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else {
        rethrow;
      }
    }
  }
}
