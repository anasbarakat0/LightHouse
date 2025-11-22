part of 'get_statistics_overview_bloc.dart';

@immutable
abstract class GetStatisticsOverviewEvent {}

class GetStatisticsOverview extends GetStatisticsOverviewEvent {
  final String? from;
  final String? to;

  GetStatisticsOverview({
    this.from,
    this.to,
  });
}

