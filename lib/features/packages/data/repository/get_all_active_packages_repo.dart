// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/packages/data/models/all_active_packages_response_model.dart';
import 'package:lighthouse_/features/packages/data/source/remote/get_all_active_packages_service.dart';

class GetAllActivePackagesRepo {
  final GetAllActivePackagesService getAllActivePackagesService;
  final NetworkConnection networkConnection;
  GetAllActivePackagesRepo({
    required this.getAllActivePackagesService,
    required this.networkConnection,
  });

  Future<Either<Failures, AllActivePackagesResponseModel>>
      getAllActivePackagesRepo(int page, int size) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await getAllActivePackagesService
            .getAllActivePackagesService(page, size);
        if (data.data["message"] == "There is no packages yet") {
          return Right(NoActivePackages.fromMap(data.data));
        } else {
          return Right(ActivePackages.fromMap(data.data));
        }
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(
          ServerFailure(
            message: e.response!.data.toString(),
          ),
        );
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}