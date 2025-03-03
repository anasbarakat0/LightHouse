// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/main_window/data/models/express_session_response_model.dart';
import 'package:lighthouse/features/main_window/data/repository/start_express_session_repo.dart';

class StartExpressSessionUsecase {
  final StartExpressSessionRepo startExpressSessionRepo;
  StartExpressSessionUsecase({
    required this.startExpressSessionRepo,
  });

  Future<Either<Failures,ExpressSessionResponseModel>> call (String fullName)async{
    return await startExpressSessionRepo.startExpressSessionRepo(fullName);
  }
}
