// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/main_window/data/models/express_session_response_model.dart';
import 'package:lighthouse/features/main_window/data/sources/start_express_session_service.dart';

class StartExpressSessionRepo {
  final StartExpressSessionService startExpressSessionService;
  final NetworkConnection networkConnection;
  StartExpressSessionRepo({
    required this.startExpressSessionService,
    required this.networkConnection,
  });

  Future<Either<Failures,ExpressSessionResponseModel>> startExpressSessionRepo(String fullName)async{
    if (await networkConnection.isConnected) {
      try {
        var data = await startExpressSessionService.startExpressSessionService(fullName);
        ExpressSessionResponseModel responseModel = ExpressSessionResponseModel.fromMap(data.data);
        return Right(responseModel);
     } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
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
