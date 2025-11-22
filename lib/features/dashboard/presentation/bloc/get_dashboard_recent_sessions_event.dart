part of 'get_dashboard_recent_sessions_bloc.dart';

abstract class GetDashboardRecentSessionsEvent {}

class GetDashboardRecentSessions extends GetDashboardRecentSessionsEvent {
  final int? limit;

  GetDashboardRecentSessions({this.limit});
}

