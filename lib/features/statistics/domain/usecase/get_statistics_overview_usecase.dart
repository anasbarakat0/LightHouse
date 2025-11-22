// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_overview_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_overview_repo.dart';

class GetStatisticsOverviewUsecase {
  final GetStatisticsOverviewRepo getStatisticsOverviewRepo;

  GetStatisticsOverviewUsecase({
    required this.getStatisticsOverviewRepo,
  });

  Future<Either<Failures, StatisticsOverviewResponseModel>> call({
    String? from,
    String? to,
  }) async {
    return await getStatisticsOverviewRepo.getStatisticsOverviewRepo(
      from: from,
      to: to,
    );
  }
}

