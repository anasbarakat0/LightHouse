part of 'get_premium_session_bloc.dart';

@immutable
abstract class GetPremiumSessionState {}

class GetPremiumSessionInitial extends GetPremiumSessionState {}

class SuccessGettingSessionById extends GetPremiumSessionState {
  final GetPremiumSessionResponse response;
  SuccessGettingSessionById({
    required this.response,
  });
}

class ExceptionGettingSessionById extends GetPremiumSessionState {
  final String message;
  ExceptionGettingSessionById({
    required this.message,
  });
}

class ForbiddenGettingSessionById extends GetPremiumSessionState {
  final String message;
  ForbiddenGettingSessionById({
    required this.message,
  });
}

class LoadingGettingSessionById extends GetPremiumSessionState {}
