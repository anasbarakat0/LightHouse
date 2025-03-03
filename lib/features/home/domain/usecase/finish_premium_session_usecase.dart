// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/finish_premium_session_response_model.dart';
import 'package:lighthouse/features/home/data/repository/finish_premium_session_repo.dart';

class FinishPremiumSessionUsecase {
  final FinishPremiumSessionRepo finishPremiumSessionRepo;
  FinishPremiumSessionUsecase({
    required this.finishPremiumSessionRepo,
  });

  Future<Either<Failures, FinishPremiumSessionResponseModel>> call(
      String id) async {
    return await finishPremiumSessionRepo.finishPremiumSessionRepo(id);
  }
}
