// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';

import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/models/admin_by_id_response_model.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/admin_by_id_service.dart';

class AdminByIdRepo {
  final AdminByIdService adminByIdService;
  final NetworkConnection networkConnection;
  AdminByIdRepo({
    required this.adminByIdService,
    required this.networkConnection,
  });

  Future<Either<Failures, AdminByIdResponseModel>> adminByIdRepo(
      String id) async {
    if (await networkConnection.isConnected) {
      try {
        print(5);
        var data = await adminByIdService.adminByIdService(id);
        print(8);
        AdminByIdResponseModel admin =
            AdminByIdResponseModel.fromMap(data.data);
        return Right(admin);
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
