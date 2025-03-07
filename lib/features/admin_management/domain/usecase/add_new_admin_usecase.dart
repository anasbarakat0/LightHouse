// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/admin_management/data/models/new_admin_model.dart';
import 'package:lighthouse/features/admin_management/data/models/new_admin_response_model.dart';
import 'package:lighthouse/features/admin_management/data/repository/add_new_admin_repo.dart';

class AddNewAdminUsecase {
  final AddNewAdminRepo addNewAdminRepo;
  AddNewAdminUsecase({
    required this.addNewAdminRepo,
  });

  Future<Either<Failures, NewAdminResponseModel>> call(
      NewAdminModel admin) async {
    return await addNewAdminRepo.addNewAdminRepo(admin);
  }
}
