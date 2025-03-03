// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/start_premium_session_service.dart';

class StartPremiumSessionRepo {
  final StartPremiumSessionService startPremiumSessionService;
  final NetworkConnection networkConnection;
  StartPremiumSessionRepo({
    required this.startPremiumSessionService,
    required this.networkConnection,
  });

  Future<Either<Failures,String>> startPremiumSessionRepo(String id)async{
    if (await networkConnection.isConnected) {
      try {
        var data = await startPremiumSessionService.startPremiumSessionService(id);
        return Right(data.data['message']);
      } on Forbidden {
        print("ForbiddenFailure");
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        print("BAD_REQUEST ServerFailure");
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        print("DioException ServerFailure");
        return Left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {
      print('OfflineFailure');
      return Left(OfflineFailure());
    }
  }
}
