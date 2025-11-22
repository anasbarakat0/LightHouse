import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/models/new_premium_client_response.dart';
import 'package:lighthouse/features/premium_client/data/models/update_premium_client_model.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/update_premium_client_service.dart';

class UpdatePremiumClientRepo {
  final UpdatePremiumClientService updatePremiumClientService;
  final NetworkConnection networkConnection;

  UpdatePremiumClientRepo({
    required this.updatePremiumClientService,
    required this.networkConnection,
  });

  Future<Either<Failures, NewPremiumClientResponseModel>>
      updatePremiumClientRepo(
          String userId, UpdatePremiumClientModel client) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await updatePremiumClientService.updatePremiumClientService(
            userId, client);
        return Right(NewPremiumClientResponseModel.fromMap(data.data));
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
            message: e.response?.data.toString() ?? "Unknown error"));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

