// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';
import 'package:lighthouse/features/login/data/models/login_model.dart';

class LoginService extends Service {
  LoginService({required super.dio});

  Future<Response> loginService(LoginModel user) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.post(
        "$baseUrl/api/v1/dashboard/admins/login",
        data: user.toMap(),
        options: getOptions(auth: false),
      );
      print("object");
      return response;
// });
//       return result;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        if (e.response!.statusCode == 431 || 
            (e.response!.data["status"] != null && e.response!.data["status"] == "100 CONTINUE")) {
          throw TOO_MANY_ATTEMPTS.fromMap(e.response!.data);
        } else if (e.response!.data["status"] == "BAD_REQUEST") {
          throw BAD_REQUEST.fromMap(e.response!.data);
        }
      }
      rethrow;
    }
  }
}
