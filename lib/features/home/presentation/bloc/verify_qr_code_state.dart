part of 'verify_qr_code_bloc.dart';

@immutable
abstract class VerifyQrCodeState {}

class VerifyQrCodeInitial extends VerifyQrCodeState {}

class VerifyQrCodeLoading extends VerifyQrCodeState {}

class VerifyQrCodeSuccess extends VerifyQrCodeState {
  final VerifyQrCodeResponseModel response;

  VerifyQrCodeSuccess({required this.response});
}

class VerifyQrCodeException extends VerifyQrCodeState {
  final String message;

  VerifyQrCodeException({required this.message});
}

class VerifyQrCodeForbidden extends VerifyQrCodeState {
  final String message;

  VerifyQrCodeForbidden({required this.message});
}

