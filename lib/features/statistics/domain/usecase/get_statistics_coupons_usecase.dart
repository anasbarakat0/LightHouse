// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_coupons_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_statistics_coupons_repo.dart';

class GetStatisticsCouponsUsecase {
  final GetStatisticsCouponsRepo getStatisticsCouponsRepo;

  GetStatisticsCouponsUsecase({
    required this.getStatisticsCouponsRepo,
  });

  Future<Either<Failures, StatisticsCouponsResponseModel>> call({
    String? from,
    String? to,
    int? top,
  }) async {
    return await getStatisticsCouponsRepo.getStatisticsCouponsRepo(
      from: from,
      to: to,
      top: top,
    );
  }
}

