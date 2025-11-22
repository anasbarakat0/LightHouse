part of 'close_express_session_by_qr_code_bloc.dart';

@immutable
abstract class CloseExpressSessionByQrCodeEvent {}

class CloseExpressSessionByQrCode extends CloseExpressSessionByQrCodeEvent {
  final String qrCode;
  CloseExpressSessionByQrCode({required this.qrCode});
}
