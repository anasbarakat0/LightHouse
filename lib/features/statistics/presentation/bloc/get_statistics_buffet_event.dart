part of 'get_statistics_buffet_bloc.dart';

@immutable
abstract class GetStatisticsBuffetEvent {}

class GetStatisticsBuffet extends GetStatisticsBuffetEvent {
  final String? from;
  final String? to;
  final int? top;

  GetStatisticsBuffet({
    this.from,
    this.to,
    this.top,
  });
}

