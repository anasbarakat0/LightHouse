part of 'start_premium_session_bloc.dart';

@immutable
abstract class StartPremiumSessionState {}

class StartPremiumSessionInitial extends StartPremiumSessionState {}

class SuccessStartSession extends StartPremiumSessionState {
  final String response;
  SuccessStartSession({
    required this.response,
  });
}


class ExceptionStartSession extends StartPremiumSessionState {
  final String message;
  ExceptionStartSession({
    required this.message,
  });
}

class ForbiddenStartSession extends StartPremiumSessionState {
  final String message;
  ForbiddenStartSession({
    required this.message,
  });
}

class LoadingStartSession extends StartPremiumSessionState{}