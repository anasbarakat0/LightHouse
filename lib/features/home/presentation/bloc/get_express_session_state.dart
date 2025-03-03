part of 'get_express_session_bloc.dart';

@immutable
abstract class GetExpressSessionState {}

class GetExpressSessionInitial extends GetExpressSessionState {}

class SuccessGettingExpressSession extends GetExpressSessionState {
  final GetExpressSessionResponse response;
  SuccessGettingExpressSession({
    required this.response,
  });
}

class ExceptionGettingExpressSession extends GetExpressSessionState {
  final String message;
  ExceptionGettingExpressSession({
    required this.message,
  });
}

class ForbiddenGettingExpressSession extends GetExpressSessionState {
  final String message;
  ForbiddenGettingExpressSession({
    required this.message,
  });
}

class LoadingGettingExpressSession extends GetExpressSessionState {}
