import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/buffet_order_request_model.dart';
import 'package:lighthouse/features/home/data/repository/premium_buffet_repo.dart';

class PremiumBuffetUsecase {
  final PremiumBuffetRepo premiumBuffetRepo;

  PremiumBuffetUsecase({
    required this.premiumBuffetRepo,
  });

  Future<Either<Failures, BuffetOperationResponseModel>>
      addOrdersToPremiumSession(
    String sessionId,
    List<BuffetOrderRequestModel> orders,
  ) {
    return premiumBuffetRepo.addOrdersToPremiumSessionRepo(sessionId, orders);
  }

  Future<Either<Failures, BuffetOperationResponseModel>>
      createBuffetInvoiceByQrCode(
    String qrCode,
    List<BuffetOrderRequestModel> orders,
  ) {
    return premiumBuffetRepo.createBuffetInvoiceByQrCodeRepo(qrCode, orders);
  }

  Future<Either<Failures, PremiumBuffetInvoicesResponseModel>>
      getPremiumBuffetInvoices(String sessionId) {
    return premiumBuffetRepo.getPremiumBuffetInvoicesRepo(sessionId);
  }

  Future<Either<Failures, BuffetOperationResponseModel>> updateBuffetOrder(
    String orderId,
    int quantity,
  ) {
    return premiumBuffetRepo.updateBuffetOrderRepo(orderId, quantity);
  }

  Future<Either<Failures, BuffetOperationResponseModel>> deleteBuffetOrder(
    String orderId,
  ) {
    return premiumBuffetRepo.deleteBuffetOrderRepo(orderId);
  }
}
