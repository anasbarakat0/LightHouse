part of 'close_express_session_by_qr_code_bloc.dart';

@immutable
abstract class CloseExpressSessionByQrCodeState {}

class CloseExpressSessionByQrCodeInitial
    extends CloseExpressSessionByQrCodeState {}

class LoadingClosingExpressSessionByQrCode
    extends CloseExpressSessionByQrCodeState {}

class SuccessClosingExpressSessionByQrCode
    extends CloseExpressSessionByQrCodeState {
  final CloseExpressSessionByQrCodeResponseModel response;
  SuccessClosingExpressSessionByQrCode({required this.response});
}

class ExceptionClosingExpressSessionByQrCode
    extends CloseExpressSessionByQrCodeState {
  final String message;
  ExceptionClosingExpressSessionByQrCode({required this.message});
}

class ForbiddenClosingExpressSessionByQrCode
    extends CloseExpressSessionByQrCodeState {
  final String message;
  ForbiddenClosingExpressSessionByQrCode({required this.message});
}
