import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/home/data/models/get_premium_session_response.dart';
import 'package:lighthouse/features/home/data/source/remote/get_premium_session_by_qr_code_service.dart';

class GetPremiumSessionByQrCodeRepo {
  final GetPremiumSessionByQrCodeService getPremiumSessionByQrCodeService;
  final NetworkConnection networkConnection;

  GetPremiumSessionByQrCodeRepo({
    required this.getPremiumSessionByQrCodeService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetPremiumSessionResponse>>
      getPremiumSessionByQrCodeRepo(String qrCode) async {
    if (await networkConnection.isConnected) {
      try {
        print("getPremiumSessionByQrCodeService(qrCode)");
        var data = await getPremiumSessionByQrCodeService
            .getPremiumSessionByQrCodeService(qrCode);
        GetPremiumSessionResponse responseModel =
            GetPremiumSessionResponse.fromMap(data.data);
        print("Right(responseModel)");
        return Right(responseModel);
      } on Forbidden {
        print("GetPremiumSessionByQrCodeRepo forbidden");
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        print("GetPremiumSessionByQrCodeRepo bad request");
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        print("GetPremiumSessionByQrCodeRepo DioException");
        print(e.response?.data);
        return Left(ServerFailure(
            message:
                e.response?.data?.toString() ?? e.message ?? "Unknown error"));
      } catch (e) {
        print("GetPremiumSessionByQrCodeRepo unknown error: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print('GetPremiumSessionByQrCodeRepo OfflineFailure');
      return Left(OfflineFailure());
    }
  }
}
