part of 'close_premium_session_by_qr_code_bloc.dart';

@immutable
abstract class ClosePremiumSessionByQrCodeState {}

class ClosePremiumSessionByQrCodeInitial
    extends ClosePremiumSessionByQrCodeState {}

class LoadingClosingPremiumSessionByQrCode
    extends ClosePremiumSessionByQrCodeState {}

class SuccessClosingPremiumSessionByQrCode
    extends ClosePremiumSessionByQrCodeState {
  final ClosePremiumSessionByQrCodeResponseModel response;
  SuccessClosingPremiumSessionByQrCode({required this.response});
}

class ExceptionClosingPremiumSessionByQrCode
    extends ClosePremiumSessionByQrCodeState {
  final String message;
  ExceptionClosingPremiumSessionByQrCode({required this.message});
}

class ForbiddenClosingPremiumSessionByQrCode
    extends ClosePremiumSessionByQrCodeState {
  final String message;
  ForbiddenClosingPremiumSessionByQrCode({required this.message});
}
