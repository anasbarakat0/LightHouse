// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/core/utils/shared_prefrences.dart';
import 'package:lighthouse_/features/login/data/models/login_model.dart';
import 'package:lighthouse_/features/login/data/models/login_response_model.dart';
import 'package:lighthouse_/features/login/data/sources/remote/login_service.dart';
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
        storage.get<SharedPreferences>().setBool("auth", true);
        storage.get<SharedPreferences>().setString("token", response.body.token);
        return Right(response);
      } on BAD_REQUEST catch (e) {
        print("loginRepo.BAD_REQUEST");
        return Left(LoginFailure(message: e.message));
      } on DioException catch (e) {
        print("loginRepo.DioException");
        return Left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {
      print("loginRepo.isNotConnected");
      return Left(OfflineFailure());
    }
  }
}
