part of 'get_statistics_sessions_bloc.dart';

@immutable
abstract class GetStatisticsSessionsState {}

class GetStatisticsSessionsInitial extends GetStatisticsSessionsState {}

class LoadingGetStatisticsSessions extends GetStatisticsSessionsState {}

class SuccessGetStatisticsSessions extends GetStatisticsSessionsState {
  final StatisticsSessionsResponseModel response;

  SuccessGetStatisticsSessions({required this.response});
}

class ExceptionGetStatisticsSessions extends GetStatisticsSessionsState {
  final String message;

  ExceptionGetStatisticsSessions({required this.message});
}

class ForbiddenGetStatisticsSessions extends GetStatisticsSessionsState {
  final String message;

  ForbiddenGetStatisticsSessions({required this.message});
}

