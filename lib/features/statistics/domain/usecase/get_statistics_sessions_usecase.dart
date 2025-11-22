// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_sessions_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_sessions_repo.dart';

class GetStatisticsSessionsUsecase {
  final GetStatisticsSessionsRepo getStatisticsSessionsRepo;

  GetStatisticsSessionsUsecase({
    required this.getStatisticsSessionsRepo,
  });

  Future<Either<Failures, StatisticsSessionsResponseModel>> call({
    String? from,
    String? to,
  }) async {
    return await getStatisticsSessionsRepo.getStatisticsSessionsRepo(
      from: from,
      to: to,
    );
  }
}

