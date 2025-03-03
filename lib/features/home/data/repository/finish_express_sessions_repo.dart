// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/home/data/models/finish_express_session_response_model.dart';
import 'package:lighthouse/features/home/data/source/remote/finish_express_sessions_service.dart';

class FinishExpressSessionsRepo {
  final FinishExpressSessionsService finishExpressSessionsService;
  final NetworkConnection networkConnection;
  FinishExpressSessionsRepo({
    required this.finishExpressSessionsService,
    required this.networkConnection,
  });

  Future<Either<Failures,FinishExpressSessionResponseModel>> finishExpressSessionsRepo(String id)async {
    if (await networkConnection.isConnected) {
      try {
        var data = await finishExpressSessionsService.finishExpressSessionsService(id);
        var respond = FinishExpressSessionResponseModel.fromMap(data.data);
        return Right(respond);
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
