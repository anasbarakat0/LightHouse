part of 'get_todays_sessions_bloc.dart';

@immutable
abstract class GetTodaysSessionsEvent {}

class GetTodaysSessions extends GetTodaysSessionsEvent {
  final int page;
  final int size;

  GetTodaysSessions({
    required this.page,
    required this.size,
  });
}

