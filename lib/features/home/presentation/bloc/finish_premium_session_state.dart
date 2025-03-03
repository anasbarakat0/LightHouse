part of 'finish_premium_session_bloc.dart';


@immutable
abstract class FinishPremiumSessionState {}

class FinishPremiumSessionInitial extends FinishPremiumSessionState {}

class SuccessFinishPremiumSession extends FinishPremiumSessionState {
  final FinishPremiumSessionResponseModel response;
  SuccessFinishPremiumSession({
    required this.response,
  });
}

class ExceptionFinishPremiumSession extends FinishPremiumSessionState {
  final String message;
  ExceptionFinishPremiumSession({
    required this.message,
  });
}

class ForbiddenFinishPremiumSession extends FinishPremiumSessionState {
  final String message;
  ForbiddenFinishPremiumSession({
    required this.message,
  });
}

class LoadingFinishPremiumSession extends FinishPremiumSessionState {}
