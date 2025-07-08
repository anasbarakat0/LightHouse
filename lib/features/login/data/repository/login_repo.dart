// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/login/data/models/login_model.dart';
import 'package:lighthouse/features/login/data/models/login_response_model.dart';
import 'package:lighthouse/features/login/data/sources/remote/login_service.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {
  final LoginService loginService;
  NetworkConnection networkConnection;

  LoginRepo(
    this.loginService,
    this.networkConnection,
  );

  Future<Either<Failures, LoginResponseModel>> loginRepo(
      LoginModel user) async {
    print("loginRepo");
    if (await networkConnection.isConnected) {
      print("loginRepo.isConnected");
      try {
        print("loginRepo.try");
        var data = await loginService.loginService(user);
        LoginResponseModel response = LoginResponseModel.fromMap(data.data);
        if (response.body.userInfo.role == "MANAGER") {
          memory.get<SharedPreferences>().setBool("MANAGER", true);
        } else {
          memory.get<SharedPreferences>().setBool("MANAGER", false);
        }
        memory.get<SharedPreferences>().setBool("auth", true);
        memory.get<SharedPreferences>().setString("userId", response.body.userInfo.id);
        memory.get<SharedPreferences>().setString("token", response.body.token);
        return Right(response);
      } on BAD_REQUEST catch (e) {
        print("loginRepo.BAD_REQUEST");
        return Left(LoginFailure(message: e.message));
      } on DioException catch (e) {
        print("loginRepo.DioException");
        print(e.response!.data);

        return Left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {
      print("loginRepo.isNotConnected");
      return Left(OfflineFailure());
    }
  }
}
