// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/admin_by_id_response_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/admin_by_id_repo.dart';

class AdminByIdUsecase {
  final AdminByIdRepo adminByIdRepo;
  AdminByIdUsecase({
    required this.adminByIdRepo,
  });

  Future<Either<Failures, AdminByIdResponseModel>> call(String id) async {
    print(4);
    return await adminByIdRepo.adminByIdRepo(id);
  }
}
