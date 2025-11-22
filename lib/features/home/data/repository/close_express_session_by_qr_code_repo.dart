import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/home/data/models/close_express_session_by_qr_code_response_model.dart';
import 'package:lighthouse/features/home/data/source/remote/close_express_session_by_qr_code_service.dart';

class CloseExpressSessionByQrCodeRepo {
  final CloseExpressSessionByQrCodeService closeExpressSessionByQrCodeService;
  final NetworkConnection networkConnection;

  CloseExpressSessionByQrCodeRepo({
    required this.closeExpressSessionByQrCodeService,
    required this.networkConnection,
  });

  Future<Either<Failures, CloseExpressSessionByQrCodeResponseModel>>
      closeExpressSessionByQrCodeRepo(String qrCode) async {
    if (await networkConnection.isConnected) {
      try {
        print("closeExpressSessionByQrCodeService(qrCode)");
        var data = await closeExpressSessionByQrCodeService
            .closeExpressSessionByQrCodeService(qrCode);
        CloseExpressSessionByQrCodeResponseModel responseModel =
            CloseExpressSessionByQrCodeResponseModel.fromMap(data.data);
        print("Right(responseModel)");
        return Right(responseModel);
      } on Forbidden {
        print("CloseExpressSessionByQrCodeRepo forbidden");
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        print("CloseExpressSessionByQrCodeRepo bad request");
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        print("CloseExpressSessionByQrCodeRepo DioException");
        print(e.response?.data);
        return Left(ServerFailure(
            message:
                e.response?.data?.toString() ?? e.message ?? "Unknown error"));
      } catch (e) {
        print("CloseExpressSessionByQrCodeRepo unknown error: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print('CloseExpressSessionByQrCodeRepo OfflineFailure');
      return Left(OfflineFailure());
    }
  }
}
