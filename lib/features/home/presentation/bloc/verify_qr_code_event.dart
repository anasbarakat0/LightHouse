part of 'verify_qr_code_bloc.dart';

@immutable
abstract class VerifyQrCodeEvent {}

class VerifyQrCode extends VerifyQrCodeEvent {
  final String qrCode;

  VerifyQrCode({required this.qrCode});
}

