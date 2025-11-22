// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/finish_express_session_response_model.dart';
import 'package:lighthouse/features/home/data/repository/finish_express_sessions_repo.dart';

class FinishExpressSessionUsecase {
  final FinishExpressSessionsRepo finishExpressSessionsRepo;
  FinishExpressSessionUsecase({
    required this.finishExpressSessionsRepo,
  });

  Future<Either<Failures, FinishExpressSessionResponseModel>> call(
    String id, {
    String? discountCode,
    double? manualDiscountAmount,
    String? manualDiscountNote,
  }) async {
    return await finishExpressSessionsRepo.finishExpressSessionsRepo(
      id,
      discountCode: discountCode,
      manualDiscountAmount: manualDiscountAmount,
      manualDiscountNote: manualDiscountNote,
    );
  }
}
