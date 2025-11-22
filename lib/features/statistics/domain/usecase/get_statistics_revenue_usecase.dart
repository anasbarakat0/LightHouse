// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_revenue_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_revenue_repo.dart';

class GetStatisticsRevenueUsecase {
  final GetStatisticsRevenueRepo getStatisticsRevenueRepo;

  GetStatisticsRevenueUsecase({
    required this.getStatisticsRevenueRepo,
  });

  Future<Either<Failures, StatisticsRevenueResponseModel>> call({
    String? from,
    String? to,
  }) async {
    return await getStatisticsRevenueRepo.getStatisticsRevenueRepo(
      from: from,
      to: to,
    );
  }
}

