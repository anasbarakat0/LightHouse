part of 'get_statistics_users_bloc.dart';

@immutable
abstract class GetStatisticsUsersEvent {}

class GetStatisticsUsers extends GetStatisticsUsersEvent {
  final String? from;
  final String? to;
  final int? top;

  GetStatisticsUsers({
    this.from,
    this.to,
    this.top,
  });
}

