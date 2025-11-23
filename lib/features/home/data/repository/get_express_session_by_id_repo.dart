import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/home/data/models/get_express_session_response.dart';
import 'package:lighthouse/features/home/data/source/remote/get_express_session_by_id_service.dart';

class GetExpressSessionByIdRepo {
  final GetExpressSessionByIdService getExpressSessionByIdService;
  final NetworkConnection networkConnection;
  GetExpressSessionByIdRepo({
    required this.getExpressSessionByIdService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetExpressSessionResponse>> getExpressSessionByIdRepo(String id) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await getExpressSessionByIdService.getExpressSessionByIdService(id);
        var model = GetExpressSessionResponse.fromMap(data.data);
        print(model.toJson());
        return Right(model);
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
