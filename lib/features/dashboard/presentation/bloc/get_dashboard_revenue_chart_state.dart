part of 'get_dashboard_revenue_chart_bloc.dart';

abstract class GetDashboardRevenueChartState {}

class GetDashboardRevenueChartInitial extends GetDashboardRevenueChartState {}

class LoadingGetDashboardRevenueChart extends GetDashboardRevenueChartState {}

class SuccessGetDashboardRevenueChart extends GetDashboardRevenueChartState {
  final DashboardRevenueChartResponseModel response;

  SuccessGetDashboardRevenueChart({required this.response});
}

class ExceptionGetDashboardRevenueChart extends GetDashboardRevenueChartState {
  final String message;

  ExceptionGetDashboardRevenueChart({required this.message});
}

class ForbiddenGetDashboardRevenueChart extends GetDashboardRevenueChartState {
  final String message;

  ForbiddenGetDashboardRevenueChart({required this.message});
}

