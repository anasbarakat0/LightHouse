part of 'get_statistics_revenue_bloc.dart';

@immutable
abstract class GetStatisticsRevenueEvent {}

class GetStatisticsRevenue extends GetStatisticsRevenueEvent {
  final String? from;
  final String? to;

  GetStatisticsRevenue({
    this.from,
    this.to,
  });
}

