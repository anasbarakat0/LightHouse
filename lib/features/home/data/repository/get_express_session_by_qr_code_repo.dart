import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/home/data/models/get_express_session_response.dart';
import 'package:lighthouse/features/home/data/source/remote/get_express_session_by_qr_code_service.dart';

class GetExpressSessionByQrCodeRepo {
  final GetExpressSessionByQrCodeService getExpressSessionByQrCodeService;
  final NetworkConnection networkConnection;

  GetExpressSessionByQrCodeRepo({
    required this.getExpressSessionByQrCodeService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetExpressSessionResponse>>
      getExpressSessionByQrCodeRepo(String qrCode) async {
    if (await networkConnection.isConnected) {
      try {
        print("getExpressSessionByQrCodeService(qrCode)");
        var data = await getExpressSessionByQrCodeService
            .getExpressSessionByQrCodeService(qrCode);
        GetExpressSessionResponse responseModel =
            GetExpressSessionResponse.fromMap(data.data);
        print("Right(responseModel)");
        return Right(responseModel);
      } on Forbidden {
        print("GetExpressSessionByQrCodeRepo forbidden");
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        print("GetExpressSessionByQrCodeRepo bad request");
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        print("GetExpressSessionByQrCodeRepo DioException");
        print(e.response?.data);
        return Left(ServerFailure(
            message:
                e.response?.data?.toString() ?? e.message ?? "Unknown error"));
      } catch (e) {
        print("GetExpressSessionByQrCodeRepo unknown error: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print('GetExpressSessionByQrCodeRepo OfflineFailure');
      return Left(OfflineFailure());
    }
  }
}
