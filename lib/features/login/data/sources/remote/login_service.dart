// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';
import 'package:lighthouse_/features/login/data/models/login_model.dart';

class LoginService extends Service {
  LoginService({required super.dio});

  Future<Response> loginService(LoginModel user) async {
    print("loginServer");
    try {
    print("loginServer.try");
      response = await dio.post(
        "$baseUrl/api/v1/dashboard/admins/login",
        data: user.toMap(),
        options: options(false),
      );
      print(response.data);
      return response;
    } on DioException catch (e) {
      print(e);
    print("loginServer.DioException");
      if (e.response!.data["status"] == "BAD_REQUEST") {
    print("loginServer.if");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else {
    print("loginServer.else");
    print("e.message: ${e.message}");
    print("e.response!.data: ${e.response!.data}");
        rethrow;
      }
    }
  }
}
