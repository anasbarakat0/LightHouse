part of 'close_premium_session_by_qr_code_bloc.dart';

@immutable
abstract class ClosePremiumSessionByQrCodeEvent {}

class ClosePremiumSessionByQrCode extends ClosePremiumSessionByQrCodeEvent {
  final String qrCode;
  ClosePremiumSessionByQrCode({required this.qrCode});
}
