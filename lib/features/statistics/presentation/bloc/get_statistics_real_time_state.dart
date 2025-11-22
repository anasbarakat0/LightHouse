part of 'get_statistics_real_time_bloc.dart';

@immutable
abstract class GetStatisticsRealTimeState {}

class GetStatisticsRealTimeInitial extends GetStatisticsRealTimeState {}

class LoadingGetStatisticsRealTime extends GetStatisticsRealTimeState {}

class SuccessGetStatisticsRealTime extends GetStatisticsRealTimeState {
  final StatisticsRealTimeResponseModel response;

  SuccessGetStatisticsRealTime({required this.response});
}

class ExceptionGetStatisticsRealTime extends GetStatisticsRealTimeState {
  final String message;

  ExceptionGetStatisticsRealTime({required this.message});
}

class ForbiddenGetStatisticsRealTime extends GetStatisticsRealTimeState {
  final String message;

  ForbiddenGetStatisticsRealTime({required this.message});
}

