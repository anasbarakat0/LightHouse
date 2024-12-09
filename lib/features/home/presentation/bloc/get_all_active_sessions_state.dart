part of 'get_all_active_sessions_bloc.dart';

@immutable
abstract class GetAllActiveSessionsState {}

class GetAllActiveSessionsInitial extends GetAllActiveSessionsState {}

class SuccessGettingSessions extends GetAllActiveSessionsState {
  final ActiveSessionsResponseModel response;
  SuccessGettingSessions({
    required this.response,
  });
}

class ExceptionGettingSessions extends GetAllActiveSessionsState {
  final String message;
  ExceptionGettingSessions({
    required this.message,
  });
}

class ForbiddenGettingSessions extends GetAllActiveSessionsState {
  final String message;
  ForbiddenGettingSessions({
    required this.message,
  });
}

class LoadingGettingSessions extends GetAllActiveSessionsState {}
