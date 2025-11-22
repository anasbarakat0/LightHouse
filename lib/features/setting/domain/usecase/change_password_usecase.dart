import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/setting/data/models/change_password_model.dart';
import 'package:lighthouse/features/setting/data/repository/change_password_repo.dart';

class ChangePasswordUsecase {
  final ChangePasswordRepo changePasswordRepo;

  ChangePasswordUsecase({required this.changePasswordRepo});

  Future<Either<Failures, String>> call(ChangePasswordModel changePasswordModel) {
    return changePasswordRepo.changePasswordRepo(changePasswordModel);
  }
}

