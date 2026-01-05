// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/update_capacity_response_model.dart';
import 'package:lighthouse/features/statistics/data/repository/update_capacity_repo.dart';

class UpdateCapacityUsecase {
  final UpdateCapacityRepo updateCapacityRepo;

  UpdateCapacityUsecase({
    required this.updateCapacityRepo,
  });

  Future<Either<Failures, UpdateCapacityResponseModel>> call(int capacity) async {
    return await updateCapacityRepo.updateCapacityRepo(capacity);
  }
}


