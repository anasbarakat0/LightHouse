import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/models/get_sessions_by_user_id_response_model.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_sessions_by_user_id_service.dart';

class GetSessionsByUserIdRepo {
  final GetSessionsByUserIdService getSessionsByUserIdService;
  final NetworkConnection networkConnection;
  GetSessionsByUserIdRepo({
    required this.getSessionsByUserIdService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetSessionsByUserIdResponseModel>>
      getSessionsByUserIdRepo(String userId, int page, int size) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await getSessionsByUserIdService.getSessionsByUserId(
            userId, page, size);
        try {
          return Right(GetSessionsByUserIdResponseModel.fromMap(data.data));
        } catch (e) {
          return Left(NoDataFailure(message: data.data["message"]));
        }
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}


