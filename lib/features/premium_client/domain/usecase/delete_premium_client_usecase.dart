import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/repository/delete_premium_client_repo.dart';

class DeletePremiumClientUsecase {
  final DeletePremiumClientRepo deletePremiumClientRepo;

  DeletePremiumClientUsecase({required this.deletePremiumClientRepo});

  Future<Either<Failures, String>> call(String userId) {
    return deletePremiumClientRepo.deletePremiumClientRepo(userId);
  }
}

