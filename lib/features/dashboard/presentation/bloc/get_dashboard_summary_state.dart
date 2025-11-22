part of 'get_dashboard_summary_bloc.dart';

abstract class GetDashboardSummaryState {}

class GetDashboardSummaryInitial extends GetDashboardSummaryState {}

class LoadingGetDashboardSummary extends GetDashboardSummaryState {}

class SuccessGetDashboardSummary extends GetDashboardSummaryState {
  final DashboardSummaryResponseModel response;

  SuccessGetDashboardSummary({required this.response});
}

class ExceptionGetDashboardSummary extends GetDashboardSummaryState {
  final String message;

  ExceptionGetDashboardSummary({required this.message});
}

class ForbiddenGetDashboardSummary extends GetDashboardSummaryState {
  final String message;

  ForbiddenGetDashboardSummary({required this.message});
}

