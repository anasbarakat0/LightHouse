import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/todays_sessions_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_todays_sessions_repo.dart';

class GetTodaysSessionsUsecase {
  final GetTodaysSessionsRepo getTodaysSessionsRepo;

  GetTodaysSessionsUsecase({required this.getTodaysSessionsRepo});

  Future<Either<Failures, TodaysSessionsResponseModel>> call(
      int page, int size) {
    return getTodaysSessionsRepo.getTodaysSessionsRepo(page, size);
  }
}

