import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_packages_by_user_id_response.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_all_packages_by_user_id_service.dart';

class GetAllPackagesByUserIdRepo {
  final GetAllPackagesByUserIdService getAllPackagesByUserIdService;
  final NetworkConnection networkConnection;
  GetAllPackagesByUserIdRepo({
    required this.getAllPackagesByUserIdService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetAllPackagesByUserIdResponse>>
      getAllPackagesByUserIdRepo(String userId, int page, int size) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await getAllPackagesByUserIdService.getAllPackagesByUserId(
            userId, page, size);
        try {
          return Right(GetAllPackagesByUserIdResponse.fromMap(data.data));
        } catch (e) {
          return Left(NoDataFailure(message: data.data["message"]));
        }
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
