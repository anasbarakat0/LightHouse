// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/exception.dart';

import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/home/data/models/active_sessions_response_model.dart';
import 'package:lighthouse_/features/home/data/source/remote/get_all_active_sessions_service.dart';

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
        print("GetAllActiveSessionsRepo try fromMap");
        ActiveSessionsResponseModel response = ActiveSessionsResponseModel.fromMap(data.data);
        print("GetAllActiveSessionsRepo response");
        return Right(response);
      } on Forbidden {
        print("GetAllActiveSessionsRepo forbidden");
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        print("GetAllActiveSessionsRepo bad request");
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        print("GetAllActiveSessionsRepo DioException");
        print(e.response!.data);
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
