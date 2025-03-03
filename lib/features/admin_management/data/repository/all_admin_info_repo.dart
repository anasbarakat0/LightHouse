import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';

import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/admin_management/data/models/all_admin_info_response.dart';
import 'package:lighthouse/features/admin_management/data/source/all_admin_info_service.dart';

class AllAdminInfoRepo {
  final AllAdminInfoService allAdminInfoService;
  NetworkConnection networkConnection;
  AllAdminInfoRepo({
    required this.allAdminInfoService,
    required this.networkConnection,
  });

  Future<Either<Failures, AllAdminInfoResponse>> allAdminInfoRepo(
      int page, int size) async {

    if (await networkConnection.isConnected) {

      try {

        var data = await allAdminInfoService.allAdminInfoService(page, size);

        AllAdminInfoResponse allAdmins =
            AllAdminInfoResponse.fromMap(data.data);

        return right(allAdmins);
      } on Forbidden {

        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on DioException catch (e) {

        return left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {

      return left(OfflineFailure());
    }
  }
}
