// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/common/model/success_response_model.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/admin_management/data/repository/delete_admin_repo.dart';

class DeleteAdminUsecase {
  final DeleteAdminRepo deleteAdminRepo;
  DeleteAdminUsecase({
    required this.deleteAdminRepo,
  });

  Future<Either<Failures, SuccessResponseModel>> call(String id) async {
    return await deleteAdminRepo.deleteAdminSRepo(id);
  }
}
