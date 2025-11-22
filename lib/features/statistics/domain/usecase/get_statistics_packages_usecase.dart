// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_packages_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_packages_repo.dart';

class GetStatisticsPackagesUsecase {
  final GetStatisticsPackagesRepo getStatisticsPackagesRepo;

  GetStatisticsPackagesUsecase({
    required this.getStatisticsPackagesRepo,
  });

  Future<Either<Failures, StatisticsPackagesResponseModel>> call({
    String? from,
    String? to,
  }) async {
    return await getStatisticsPackagesRepo.getStatisticsPackagesRepo(
      from: from,
      to: to,
    );
  }
}

