// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/packages/data/models/all_active_packages_response_model.dart';
import 'package:lighthouse/features/packages/data/repository/get_all_active_packages_repo.dart';

class GetAllActivePackagesUsecase {
  final GetAllActivePackagesRepo getAllActivePackagesRepo;
  GetAllActivePackagesUsecase({
    required this.getAllActivePackagesRepo,
  });

  Future<Either<Failures, AllActivePackagesResponseModel>> call(
      int page, int size) async {
    return await getAllActivePackagesRepo.getAllActivePackagesRepo(page, size);
  }
}
