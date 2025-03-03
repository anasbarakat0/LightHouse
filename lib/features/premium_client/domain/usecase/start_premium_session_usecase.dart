// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/repository/start_premium_session_repo.dart';

class StartPremiumSessionUsecase {
  final StartPremiumSessionRepo startPremiumSessionRepo;
  StartPremiumSessionUsecase({
    required this.startPremiumSessionRepo,
  });

  Future<Either<Failures,String>> call (String id)async{
    return await startPremiumSessionRepo.startPremiumSessionRepo(id);
  }
}