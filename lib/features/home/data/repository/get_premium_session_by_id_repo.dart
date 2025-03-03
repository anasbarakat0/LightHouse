// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';

import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/home/data/models/get_premium_session_response.dart';
import 'package:lighthouse/features/home/data/source/remote/get_premium_session_by_id_service.dart';

class GetPremiumSessionByIdRepo {
  final GetPremiumSessionByIdService getPremiumSessionByIdService;
  final NetworkConnection networkConnection;
  GetPremiumSessionByIdRepo({
    required this.getPremiumSessionByIdService,
    required this.networkConnection,
  });

  Future<Either<Failures,GetPremiumSessionResponse>> getPremiumSessionByIdRepo(String id)async{
    if (await networkConnection.isConnected) {
      try {
        var data = await getPremiumSessionByIdService.getPremiumSessionByIdService(id);
        return Right(GetPremiumSessionResponse.fromMap(data.data));
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
