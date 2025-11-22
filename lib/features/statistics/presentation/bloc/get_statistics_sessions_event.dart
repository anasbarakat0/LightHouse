part of 'get_statistics_sessions_bloc.dart';

@immutable
abstract class GetStatisticsSessionsEvent {}

class GetStatisticsSessions extends GetStatisticsSessionsEvent {
  final String? from;
  final String? to;

  GetStatisticsSessions({
    this.from,
    this.to,
  });
}

