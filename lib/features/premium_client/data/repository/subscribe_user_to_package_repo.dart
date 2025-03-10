import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/models/subscribe_user_to_package_response.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/subscribe_user_to_package_service.dart';

class SubscribeUserToPackageRepo {
  final SubscribeUserToPackageService subscribeUserToPackageService;
  final NetworkConnection networkConnection;
  
  SubscribeUserToPackageRepo({
    required this.subscribeUserToPackageService,
    required this.networkConnection,
  });

  Future<Either<Failures, SubscribeUserToPackageResponse>> subscribeUserToPackageRepo(
      String packageId, String userId) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await subscribeUserToPackageService.subscribeUserToPackage(packageId, userId);
        return Right(SubscribeUserToPackageResponse.fromMap(data.data));
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
