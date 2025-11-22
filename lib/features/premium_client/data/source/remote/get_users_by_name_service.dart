import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetUsersByNameService extends Service {
  GetUsersByNameService({required super.dio});

  Future<Response> getUsersByNameService(String name) async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/dashboard/users/by-name",
        queryParameters: {'name': name},
        options: getOptions(auth: true),
      );

      // Check for empty response or no data
      if (response.data['message'] == "There is no users" ||
          response.data['message'] == "No users found") {
        throw NoData(message: response.data['message']);
      }

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data["status"] == "BAD_REQUEST") {
          print("BAD_REQUEST in GetUsersByNameService");
          throw BAD_REQUEST.fromMap(e.response!.data);
        } else if (e.response!.data['status'] == 403 ||
            e.response!.statusCode == 403) {
          print("Forbidden in GetUsersByNameService");
          throw Forbidden();
        }
      }
      print("DioException in GetUsersByNameService: ${e.message}");
      rethrow;
    }
  }
}
