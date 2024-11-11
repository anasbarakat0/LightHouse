// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/packages/data/models/edit_package_model.dart';
import 'package:lighthouse_/features/packages/data/models/edit_packate_info_response_model.dart';
import 'package:lighthouse_/features/packages/data/repository/edit_package_info_repo.dart';

class EditPackageInfoUsecase {
  final EditPackageInfoRepo editPackageInfoRepo;
  EditPackageInfoUsecase({
    required this.editPackageInfoRepo,
  });

  Future<Either<Failures, EditPackageInfoResponseModel>> call(
      String id, PackageModel package) async {
        return await editPackageInfoRepo.editPackageInfoRepo(id, package);
      }
}
