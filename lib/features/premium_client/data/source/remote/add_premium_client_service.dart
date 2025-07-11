import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';
import 'package:lighthouse/features/premium_client/data/models/premium_client_model.dart';

class AddPremiumClientService extends Service {
  AddPremiumClientService({required super.dio});

  Future<Response> addPremiumClientService(PremiumClient client) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.post(
        "$baseUrl/api/v1/dashboard/users/new-premium-user",
        options: getOptions(auth: true),
        data: client.toMap(),
      );
      return response;
// });
//       return result;
    } on DioException catch (e) {
      if (e.response!.data["status"] == "BAD_REQUEST") {
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else {
        rethrow;
      }
    }
  }
}
