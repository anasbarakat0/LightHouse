import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/home/data/models/buffet_order_request_model.dart';
import 'package:lighthouse/features/home/data/source/remote/premium_buffet_service.dart';

class PremiumBuffetRepo {
  final PremiumBuffetService premiumBuffetService;
  final NetworkConnection networkConnection;

  PremiumBuffetRepo({
    required this.premiumBuffetService,
    required this.networkConnection,
  });

  Future<Either<Failures, BuffetOperationResponseModel>>
      addOrdersToPremiumSessionRepo(
    String sessionId,
    List<BuffetOrderRequestModel> orders,
  ) async {
    if (await networkConnection.isConnected) {
      try {
        final data = await premiumBuffetService
            .addOrdersToPremiumSessionService(sessionId, orders);
        return Right(BuffetOperationResponseModel.fromMap(data.data));
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
          message: e.response?.data?.toString() ?? e.message ?? '',
        ));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failures, BuffetOperationResponseModel>>
      createBuffetInvoiceByQrCodeRepo(
    String qrCode,
    List<BuffetOrderRequestModel> orders,
  ) async {
    if (await networkConnection.isConnected) {
      try {
        final data = await premiumBuffetService
            .createBuffetInvoiceByQrCodeService(qrCode, orders);
        return Right(BuffetOperationResponseModel.fromMap(data.data));
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
          message: e.response?.data?.toString() ?? e.message ?? '',
        ));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failures, PremiumBuffetInvoicesResponseModel>>
      getPremiumBuffetInvoicesRepo(String sessionId) async {
    if (await networkConnection.isConnected) {
      try {
        final data = await premiumBuffetService
            .getPremiumBuffetInvoicesService(sessionId);
        return Right(PremiumBuffetInvoicesResponseModel.fromMap(data.data));
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
          message: e.response?.data?.toString() ?? e.message ?? '',
        ));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failures, BuffetOperationResponseModel>> updateBuffetOrderRepo(
    String orderId,
    int quantity,
  ) async {
    if (await networkConnection.isConnected) {
      try {
        final data = await premiumBuffetService.updateBuffetOrderService(
            orderId, quantity);
        return Right(BuffetOperationResponseModel.fromMap(data.data));
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
          message: e.response?.data?.toString() ?? e.message ?? '',
        ));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failures, BuffetOperationResponseModel>> deleteBuffetOrderRepo(
      String orderId) async {
    if (await networkConnection.isConnected) {
      try {
        final data =
            await premiumBuffetService.deleteBuffetOrderService(orderId);
        return Right(BuffetOperationResponseModel.fromMap(data.data));
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
          message: e.response?.data?.toString() ?? e.message ?? '',
        ));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
