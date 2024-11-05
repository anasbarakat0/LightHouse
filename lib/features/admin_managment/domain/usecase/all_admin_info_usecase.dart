import 'package:dartz/dartz.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/admin_managment/data/models/all_admin_info_response.dart';
import 'package:lighthouse_/features/admin_managment/data/repository/all_admin_info_repo.dart';

class AllAdminInfoUsecase {
  final AllAdminInfoRepo allAdminInfoRepo;
  AllAdminInfoUsecase(this.allAdminInfoRepo);

  Future<Either<Failures, AllAdminInfoResponse>> call(
      int page, int size) async {
    print("usecase");
    return await allAdminInfoRepo.allAdminInfoRepo(page, size);
  }
}
