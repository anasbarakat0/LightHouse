// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/packages/data/models/edit_package_model.dart';
import 'package:lighthouse_/features/packages/data/models/edit_packate_info_response_model.dart';
import 'package:lighthouse_/features/packages/data/source/remote/edit_package_info_service.dart';

class EditPackageInfoRepo {
  final EditPackageInfoService editPackageInfoService;
  final NetworkConnection networkConnection;
  EditPackageInfoRepo({
    required this.editPackageInfoService,
    required this.networkConnection,
  });

  Future<Either<Failures, EditPackageInfoResponseModel>> editPackageInfoRepo(
      String id, PackageModel package) async {
    if (await networkConnection.isConnected) {
      try {
        var data =
            await editPackageInfoService.editPackageInfoService(id, package);
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
