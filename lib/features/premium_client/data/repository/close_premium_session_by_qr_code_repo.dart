import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/models/close_premium_session_by_qr_code_response_model.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/close_premium_session_by_qr_code_service.dart';

class ClosePremiumSessionByQrCodeRepo {
  final ClosePremiumSessionByQrCodeService closePremiumSessionByQrCodeService;
  final NetworkConnection networkConnection;

  ClosePremiumSessionByQrCodeRepo({
    required this.closePremiumSessionByQrCodeService,
    required this.networkConnection,
  });

  Future<Either<Failures, ClosePremiumSessionByQrCodeResponseModel>>
      closePremiumSessionByQrCodeRepo(String qrCode) async {
    if (await networkConnection.isConnected) {
      try {
        print("closePremiumSessionByQrCodeService(qrCode)");
        var data = await closePremiumSessionByQrCodeService
            .closePremiumSessionByQrCodeService(qrCode);
        ClosePremiumSessionByQrCodeResponseModel responseModel =
            ClosePremiumSessionByQrCodeResponseModel.fromMap(data.data);
        print("Right(responseModel)");
        return Right(responseModel);
      } on Forbidden {
        print("ClosePremiumSessionByQrCodeRepo forbidden");
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        print("ClosePremiumSessionByQrCodeRepo bad request");
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        print("ClosePremiumSessionByQrCodeRepo DioException");
        print(e.response?.data);
        return Left(ServerFailure(
            message:
                e.response?.data?.toString() ?? e.message ?? "Unknown error"));
      } catch (e) {
        print("ClosePremiumSessionByQrCodeRepo unknown error: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print('ClosePremiumSessionByQrCodeRepo OfflineFailure');
      return Left(OfflineFailure());
    }
  }
}
