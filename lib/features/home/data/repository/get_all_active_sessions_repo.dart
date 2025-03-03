// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';

import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/home/data/models/active_sessions_response_model.dart';
import 'package:lighthouse/features/home/data/source/remote/get_all_active_sessions_service.dart';

class GetAllActiveSessionsRepo {
  final GetAllActiveSessionsService getAllActiveSessionsService;
  final NetworkConnection networkConnection;
  GetAllActiveSessionsRepo({
    required this.getAllActiveSessionsService,
    required this.networkConnection,
  });

  Future<Either<Failures,ActiveSessionsResponseModel>> getAllActiveSessionsRepo()async{
    if (await networkConnection.isConnected) {
      try {
        var data = await getAllActiveSessionsService.getAllActiveSessionsService();
       
        ActiveSessionsResponseModel response = ActiveSessionsResponseModel.fromMap(data.data);
        
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
