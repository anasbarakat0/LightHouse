part of 'finish_express_session_bloc.dart';

@immutable
abstract class FinishExpressSessionState {}

class FinishExpressSessionInitial extends FinishExpressSessionState {}

class SuccessFinishExpressSession extends FinishExpressSessionState {
  final FinishExpressSessionResponseModel response;
  SuccessFinishExpressSession({
    required this.response,
  });
}

class ExceptionFinishExpressSession extends FinishExpressSessionState {
  final String message;
  ExceptionFinishExpressSession({
    required this.message,
  });
}

class ForbiddenFinishExpressSession extends FinishExpressSessionState {
  final String message;
  ForbiddenFinishExpressSession({
    required this.message,
  });
}

class LoadingFinishExpressSession extends FinishExpressSessionState {}
