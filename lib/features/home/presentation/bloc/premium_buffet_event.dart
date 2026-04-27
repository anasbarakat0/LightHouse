part of 'premium_buffet_bloc.dart';

@immutable
abstract class PremiumBuffetEvent {}

class AddBuffetOrdersToPremiumSession extends PremiumBuffetEvent {
  final String sessionId;
  final List<BuffetOrderRequestModel> orders;

  AddBuffetOrdersToPremiumSession({
    required this.sessionId,
    required this.orders,
  });
}

class CreateBuffetInvoiceByQrCode extends PremiumBuffetEvent {
  final String qrCode;
  final List<BuffetOrderRequestModel> orders;

  CreateBuffetInvoiceByQrCode({
    required this.qrCode,
    required this.orders,
  });
}

class GetPremiumBuffetInvoices extends PremiumBuffetEvent {
  final String sessionId;

  GetPremiumBuffetInvoices({
    required this.sessionId,
  });
}

class UpdateBuffetOrderQuantity extends PremiumBuffetEvent {
  final String sessionId;
  final String orderId;
  final int quantity;

  UpdateBuffetOrderQuantity({
    required this.sessionId,
    required this.orderId,
    required this.quantity,
  });
}

class DeleteBuffetOrder extends PremiumBuffetEvent {
  final String sessionId;
  final String orderId;

  DeleteBuffetOrder({
    required this.sessionId,
    required this.orderId,
  });
}
