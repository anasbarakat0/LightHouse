import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse_/common/model/success_response_model.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/admin_managment/data/source/delete_admin_service.dart';

class DeleteAdminRepo {
  final DeleteAdminService deleteAdminService;
  final NetworkConnection networkConnection;

  DeleteAdminRepo(this.deleteAdminService, this.networkConnection);

  Future<Either<Failures, SuccessResponseModel>> deleteAdminSRepo(
      String id) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await deleteAdminService.deleteAdminService(id);
        return Right(SuccessResponseModel.fromMap(data.data));
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {
      return left(OfflineFailure());
    }
  }
}
