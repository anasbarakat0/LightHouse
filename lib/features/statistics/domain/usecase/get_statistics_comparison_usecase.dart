// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_comparison_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_comparison_repo.dart';

class GetStatisticsComparisonUsecase {
  final GetStatisticsComparisonRepo getStatisticsComparisonRepo;

  GetStatisticsComparisonUsecase({
    required this.getStatisticsComparisonRepo,
  });

  Future<Either<Failures, StatisticsComparisonResponseModel>> call({
    required String currentFrom,
    required String currentTo,
    required String previousFrom,
    required String previousTo,
  }) async {
    return await getStatisticsComparisonRepo.getStatisticsComparisonRepo(
      currentFrom: currentFrom,
      currentTo: currentTo,
      previousFrom: previousFrom,
      previousTo: previousTo,
    );
  }
}

