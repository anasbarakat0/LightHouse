// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/packages/data/models/edit_package_model.dart';
import 'package:lighthouse/features/packages/data/models/edit_packate_info_response_model.dart';
import 'package:lighthouse/features/packages/data/source/remote/add_new_package_service.dart';

class AddNewPackageRepo {
  final AddNewPackageService addNewPackageService;
  final NetworkConnection networkConnection;
  AddNewPackageRepo({
    required this.addNewPackageService,
    required this.networkConnection,
  });

  Future<Either<Failures, EditPackageInfoResponseModel>> addNewPackageRepo(
      PackageModel package) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await addNewPackageService.addNewPackageService(package);
        return Right(EditPackageInfoResponseModel.fromMap(data.data));
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
