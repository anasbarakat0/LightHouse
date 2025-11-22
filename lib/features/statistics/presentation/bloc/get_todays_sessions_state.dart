part of 'get_todays_sessions_bloc.dart';

@immutable
abstract class GetTodaysSessionsState {}

class GetTodaysSessionsInitial extends GetTodaysSessionsState {}

class LoadingGetTodaysSessions extends GetTodaysSessionsState {}

class SuccessGetTodaysSessions extends GetTodaysSessionsState {
  final TodaysSessionsResponseModel response;

  SuccessGetTodaysSessions({required this.response});
}

class NoTodaysSessions extends GetTodaysSessionsState {
  final String message;

  NoTodaysSessions({required this.message});
}

class ExceptionGetTodaysSessions extends GetTodaysSessionsState {
  final String message;

  ExceptionGetTodaysSessions({required this.message});
}

class OfflineFailureGetTodaysSessions extends GetTodaysSessionsState {
  final String message;

  OfflineFailureGetTodaysSessions({required this.message});
}

