import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_active_packages_response.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_all_active_packages_service.dart';

class GetAllActivePackagesRepo {
  final GetAllActivePackagesService getAllActivePackagesService;
  final NetworkConnection networkConnection;
  GetAllActivePackagesRepo({
    required this.getAllActivePackagesService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetAllActivePackagesResponse>> getAllActivePackagesRepo(int page, int size) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await getAllActivePackagesService.getAllActivePackages(page, size);
        try {
        return Right(GetAllActivePackagesResponse.fromMap(data.data));
          
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
