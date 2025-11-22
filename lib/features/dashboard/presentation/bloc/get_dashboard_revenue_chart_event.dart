part of 'get_dashboard_revenue_chart_bloc.dart';

abstract class GetDashboardRevenueChartEvent {}

class GetDashboardRevenueChart extends GetDashboardRevenueChartEvent {
  final String? period;
  final String? from;
  final String? to;

  GetDashboardRevenueChart({
    this.period,
    this.from,
    this.to,
  });
}

