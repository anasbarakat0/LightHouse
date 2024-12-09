// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/home/data/models/active_sessions_response_model.dart';
import 'package:lighthouse_/features/home/data/repository/get_all_active_sessions_repo.dart';

class GetAllActiveSessionsUsecase {
  final GetAllActiveSessionsRepo getAllActiveSessionsRepo;
  GetAllActiveSessionsUsecase({
    required this.getAllActiveSessionsRepo,
  });

  Future<Either<Failures,ActiveSessionsResponseModel>> call()async{
    return await getAllActiveSessionsRepo.getAllActiveSessionsRepo();
  }
}
