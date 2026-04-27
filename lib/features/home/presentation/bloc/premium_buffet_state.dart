part of 'premium_buffet_bloc.dart';

@immutable
abstract class PremiumBuffetState {}

class PremiumBuffetInitial extends PremiumBuffetState {}

class PremiumBuffetLoading extends PremiumBuffetState {}

class PremiumBuffetActionSuccess extends PremiumBuffetState {
  final BuffetOperationResponseModel response;
  final String? sessionId;

  PremiumBuffetActionSuccess({
    required this.response,
    this.sessionId,
  });
}

class PremiumBuffetInvoicesLoaded extends PremiumBuffetState {
  final PremiumBuffetInvoicesResponseModel response;
  final String sessionId;

  PremiumBuffetInvoicesLoaded({
    required this.response,
    required this.sessionId,
  });
}

class PremiumBuffetException extends PremiumBuffetState {
  final String message;

  PremiumBuffetException({
    required this.message,
  });
}

class PremiumBuffetForbidden extends PremiumBuffetState {
  final String message;

  PremiumBuffetForbidden({
    required this.message,
  });
}
