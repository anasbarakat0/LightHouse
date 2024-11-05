// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse_/features/premium_client/data/source/remote/get_all_premium_clients_service.dart';

class GetAllPremiumClientsRepo {
  final GetAllPremiumClientsService getAllPremiumClientsService;
  final NetworkConnection networkConnection;
  GetAllPremiumClientsRepo({
    required this.getAllPremiumClientsService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetAllPremiumclientResponseModel>> getAllPremiumClientsRepo(
      int page, int size) async {
    if (await networkConnection.isConnected) {
      print('if network');
      try {
        print("87542");
        var data = await getAllPremiumClientsService
            .getAllPremiumClientsService(page, size);
            GetAllPremiumclientResponseModel responseModel = GetAllPremiumclientResponseModel.fromMap(data.data);
        print("87543");
        return Right(responseModel);
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {
      print('else network');
      return Left(OfflineFailure());
    }
  }
}
