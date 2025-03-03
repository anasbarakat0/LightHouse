import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/admin_management/data/models/all_admin_info_response.dart';
import 'package:lighthouse/features/admin_management/data/repository/all_admin_info_repo.dart';

class AllAdminInfoUsecase {
  final AllAdminInfoRepo allAdminInfoRepo;
  AllAdminInfoUsecase(this.allAdminInfoRepo);

  Future<Either<Failures, AllAdminInfoResponse>> call(
      int page, int size) async {

    return await allAdminInfoRepo.allAdminInfoRepo(page, size);
  }
}
