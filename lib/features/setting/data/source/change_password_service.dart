import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
import 'package:lighthouse/features/setting/data/models/change_password_model.dart';

class ChangePasswordService extends Service {
  ChangePasswordService({required super.dio});

  Future<Response> changePassword(
      ChangePasswordModel changePasswordModel) async {
    try {
      response = await dio.put(
        "$baseUrl/api/v1/dashboard/admins/change-password",
        options: getOptions(auth: true).copyWith(
          responseType: ResponseType.plain, // Accept plain text response
        ),
        data: changePasswordModel.toMap(),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle both JSON and plain text error responses
        if (e.response!.data is Map<String, dynamic>) {
          if (e.response!.data["status"] == "BAD_REQUEST") {
            throw BAD_REQUEST.fromMap(e.response!.data);
          } else if (e.response!.data['status'] == 403 ||
              e.response!.statusCode == 403) {
            throw Forbidden();
          }
        } else if (e.response!.statusCode == 403) {
          throw Forbidden();
        }
      }
      rethrow;
    }
  }
}
