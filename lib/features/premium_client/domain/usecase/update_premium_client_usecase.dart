import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/new_premium_client_response.dart';
import 'package:lighthouse/features/premium_client/data/models/update_premium_client_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/update_premium_client_repo.dart';

class UpdatePremiumClientUsecase {
  final UpdatePremiumClientRepo updatePremiumClientRepo;

  UpdatePremiumClientUsecase({required this.updatePremiumClientRepo});

  Future<Either<Failures, NewPremiumClientResponseModel>> call(
      String userId, UpdatePremiumClientModel client) {
    return updatePremiumClientRepo.updatePremiumClientRepo(userId, client);
  }
}

