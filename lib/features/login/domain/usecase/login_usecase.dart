import 'package:dartz/dartz.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/login/data/models/login_model.dart';
import 'package:lighthouse_/features/login/data/models/login_response_model.dart';
import 'package:lighthouse_/features/login/data/repository/login_repo.dart';

class LoginUsecase {
  final LoginRepo loginRepo;

  LoginUsecase({required this.loginRepo});


  Future<Either<Failures,LoginResponseModel>> call(LoginModel user)async{
    print("usecase");
    return await loginRepo.loginRepo(user);
  }
}