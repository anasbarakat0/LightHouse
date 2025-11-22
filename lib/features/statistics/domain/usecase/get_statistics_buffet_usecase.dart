// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_buffet_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_buffet_repo.dart';

class GetStatisticsBuffetUsecase {
  final GetStatisticsBuffetRepo getStatisticsBuffetRepo;

  GetStatisticsBuffetUsecase({
    required this.getStatisticsBuffetRepo,
  });

  Future<Either<Failures, StatisticsBuffetResponseModel>> call({
    String? from,
    String? to,
    int? top,
  }) async {
    return await getStatisticsBuffetRepo.getStatisticsBuffetRepo(
      from: from,
      to: to,
      top: top,
    );
  }
}

