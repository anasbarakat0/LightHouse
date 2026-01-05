// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/home/data/models/finish_premium_session_response_model.dart';
import 'package:lighthouse/features/home/data/source/remote/finish_premium_session_service.dart';

class FinishPremiumSessionRepo {
  final FinishPremiumSessionService finishPremiumSessionService;
  final NetworkConnection networkConnection;
  FinishPremiumSessionRepo({
    required this.finishPremiumSessionService,
    required this.networkConnection,
  });

  Future<Either<Failures, FinishPremiumSessionResponseModel>>
      finishPremiumSessionRepo(
    String id, {
    String? discountCode,
    double? manualDiscountAmount,
    String? manualDiscountNote,
  }) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await finishPremiumSessionService.finishPremiumSessionService(
          id,
          discountCode: discountCode,
          manualDiscountAmount: manualDiscountAmount,
          manualDiscountNote: manualDiscountNote,
        );
        
        var response = FinishPremiumSessionResponseModel.fromMap(data.data);
        return Right(response);
      } on Forbidden {
       
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
       
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
     
        return Left(
          ServerFailure(
            message: e.response!.data.toString(),
          ),
        );
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
