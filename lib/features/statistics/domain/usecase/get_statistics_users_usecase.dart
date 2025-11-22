// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_users_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_users_repo.dart';

class GetStatisticsUsersUsecase {
  final GetStatisticsUsersRepo getStatisticsUsersRepo;

  GetStatisticsUsersUsecase({
    required this.getStatisticsUsersRepo,
  });

  Future<Either<Failures, StatisticsUsersResponseModel>> call({
    String? from,
    String? to,
    int? top,
  }) async {
    return await getStatisticsUsersRepo.getStatisticsUsersRepo(
      from: from,
      to: to,
      top: top,
    );
  }
}

