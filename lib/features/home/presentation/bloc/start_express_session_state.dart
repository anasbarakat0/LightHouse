// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'start_express_session_bloc.dart';

@immutable
abstract class StartExpressSessionState {}

class StartExpressSessionInitial extends StartExpressSessionState {}

class SessionStarted extends StartExpressSessionState {
  final ExpressSessionResponseModel response;
  SessionStarted({
    required this.response,
  });
}


class ExceptionSessionStarted extends StartExpressSessionState {
  final String message;
  ExceptionSessionStarted({
    required this.message,
  });
}

class ForbiddenSessionStarted extends StartExpressSessionState {
  final String message;
  ForbiddenSessionStarted({
    required this.message,
  });
}

class LoadingSessionStarted extends StartExpressSessionState {}
