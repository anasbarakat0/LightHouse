// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_real_time_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_real_time_repo.dart';

class GetStatisticsRealTimeUsecase {
  final GetStatisticsRealTimeRepo getStatisticsRealTimeRepo;

  GetStatisticsRealTimeUsecase({
    required this.getStatisticsRealTimeRepo,
  });

  Future<Either<Failures, StatisticsRealTimeResponseModel>> call() async {
    return await getStatisticsRealTimeRepo.getStatisticsRealTimeRepo();
  }
}

