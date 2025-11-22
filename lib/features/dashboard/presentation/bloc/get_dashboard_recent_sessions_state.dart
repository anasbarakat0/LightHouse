part of 'get_dashboard_recent_sessions_bloc.dart';

abstract class GetDashboardRecentSessionsState {}

class GetDashboardRecentSessionsInitial extends GetDashboardRecentSessionsState {}

class LoadingGetDashboardRecentSessions extends GetDashboardRecentSessionsState {}

class SuccessGetDashboardRecentSessions extends GetDashboardRecentSessionsState {
  final DashboardRecentSessionsResponseModel response;

  SuccessGetDashboardRecentSessions({required this.response});
}

class ExceptionGetDashboardRecentSessions extends GetDashboardRecentSessionsState {
  final String message;

  ExceptionGetDashboardRecentSessions({required this.message});
}

class ForbiddenGetDashboardRecentSessions extends GetDashboardRecentSessionsState {
  final String message;

  ForbiddenGetDashboardRecentSessions({required this.message});
}

