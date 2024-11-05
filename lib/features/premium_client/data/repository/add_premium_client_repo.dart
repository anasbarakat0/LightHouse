import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/premium_client/data/models/new_premium_client_response.dart';
import 'package:lighthouse_/features/premium_client/data/models/premium_client_model.dart';
import 'package:lighthouse_/features/premium_client/data/source/remote/add_premium_client_service.dart';

class AddPremiumClientRepo {
  final AddPremiumClientService addPremiumClientService;
  final NetworkConnection networkConnection;
  AddPremiumClientRepo(this.addPremiumClientService, this.networkConnection);

  Future<Either<Failures, NewPremiumClientResponseModel>> addPremiumClientRepo(
      PremiumClient client) async {
    if (await networkConnection.isConnected) {
      try {
        var data =
            await addPremiumClientService.addPremiumClientService(client);
        return Right(NewPremiumClientResponseModel.fromMap(data.data));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(message: e.response!.data.toString()));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
