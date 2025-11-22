import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/features/home/data/models/verify_qr_code_response_model.dart';
import 'package:lighthouse/features/home/data/source/remote/verify_qr_code_service.dart';

class VerifyQrCodeRepo {
  final VerifyQrCodeService verifyQrCodeService;
  final NetworkConnection networkConnection;

  VerifyQrCodeRepo({
    required this.verifyQrCodeService,
    required this.networkConnection,
  });

  Future<Either<Failures, VerifyQrCodeResponseModel>> verifyQrCodeRepo(
      String qrCode) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await verifyQrCodeService.verifyQrCodeService(qrCode);
        var response = VerifyQrCodeResponseModel.fromMap(data.data);
        return Right(response);
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
            message:
                e.response?.data?.toString() ?? e.message ?? "Unknown error"));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

