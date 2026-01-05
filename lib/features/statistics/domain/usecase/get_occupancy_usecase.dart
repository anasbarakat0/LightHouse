// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/occupancy_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/get_occupancy_repo.dart';

class GetOccupancyUsecase {
  final GetOccupancyRepo getOccupancyRepo;

  GetOccupancyUsecase({
    required this.getOccupancyRepo,
  });

  Future<Either<Failures, OccupancyResponseModel>> call() async {
    return await getOccupancyRepo.getOccupancyRepo();
  }
}


