part of 'get_dashboard_alerts_bloc.dart';

abstract class GetDashboardAlertsState {}

class GetDashboardAlertsInitial extends GetDashboardAlertsState {}

class LoadingGetDashboardAlerts extends GetDashboardAlertsState {}

class SuccessGetDashboardAlerts extends GetDashboardAlertsState {
  final DashboardAlertsResponseModel response;

  SuccessGetDashboardAlerts({required this.response});
}

class ExceptionGetDashboardAlerts extends GetDashboardAlertsState {
  final String message;

  ExceptionGetDashboardAlerts({required this.message});
}

class ForbiddenGetDashboardAlerts extends GetDashboardAlertsState {
  final String message;

  ForbiddenGetDashboardAlerts({required this.message});
}

