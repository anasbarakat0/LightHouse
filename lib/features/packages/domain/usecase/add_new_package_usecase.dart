// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/packages/data/models/edit_package_model.dart';
import 'package:lighthouse_/features/packages/data/models/edit_packate_info_response_model.dart';
import 'package:lighthouse_/features/packages/data/repository/add_new_package_repo.dart';

class AddNewPackageUsecase {
  final AddNewPackageRepo addNewPackageRepo;
  AddNewPackageUsecase({
    required this.addNewPackageRepo,
  });

  Future<Either<Failures, EditPackageInfoResponseModel>> call(PackageModel package)async{
    return await addNewPackageRepo.addNewPackageRepo(package);
  }
}
