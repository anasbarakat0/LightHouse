import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/exception.dart';

import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/admin_managment/data/models/all_admin_info_response.dart';
import 'package:lighthouse_/features/admin_managment/data/source/all_admin_info_service.dart';

class AllAdminInfoRepo {
  final AllAdminInfoService allAdminInfoService;
  NetworkConnection networkConnection;
  AllAdminInfoRepo({
    required this.allAdminInfoService,
    required this.networkConnection,
  });

  Future<Either<Failures, AllAdminInfoResponse>> allAdminInfoRepo(
      int page, int size) async {
        print("repo");
    if (await networkConnection.isConnected) {
      print("if");
      try {
        print("12322");
        var data = await allAdminInfoService.allAdminInfoService(page, size);
        print(data);
        AllAdminInfoResponse allAdmins =
            AllAdminInfoResponse.fromMap(data.data);
        print("done");
        return right(allAdmins);
      } on Forbidden {
        print("Forbidden all admin info");
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on DioException catch (e) {
        print(e.response!.data);
        return left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {
      print("sduklfhsfghjkzsdfgh");
      return left(OfflineFailure());
    }
  }
}
