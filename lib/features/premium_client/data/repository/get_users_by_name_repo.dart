import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/models/get_users_by_name_response_model.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_users_by_name_service.dart';

class GetUsersByNameRepo {
  final GetUsersByNameService getUsersByNameService;
  final NetworkConnection networkConnection;

  GetUsersByNameRepo({
    required this.getUsersByNameService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetUsersByNameResponseModel>> getUsersByNameRepo(
      String name) async {
    if (await networkConnection.isConnected) {
      try {
        print("getUsersByNameService(name)");
        var data = await getUsersByNameService.getUsersByNameService(name);
        GetUsersByNameResponseModel responseModel =
            GetUsersByNameResponseModel.fromMap(data.data);
        print("Right(responseModel)");
        return Right(responseModel);
      } on Forbidden {
        print("GetUsersByNameRepo forbidden");
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        print("GetUsersByNameRepo bad request");
        return Left(ServerFailure(message: e.message));
      } on NoData catch (e) {
        print("GetUsersByNameRepo no data");
        return Left(NoDataFailure(message: e.message));
      } on DioException catch (e) {
        print("GetUsersByNameRepo DioException");
        print(e.response?.data);
        return Left(ServerFailure(
            message:
                e.response?.data?.toString() ?? e.message ?? "Unknown error"));
      } catch (e) {
        print("GetUsersByNameRepo unknown error: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print('GetUsersByNameRepo OfflineFailure');
      return Left(OfflineFailure());
    }
  }
}
