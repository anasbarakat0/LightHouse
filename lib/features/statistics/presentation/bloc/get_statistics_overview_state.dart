part of 'get_statistics_overview_bloc.dart';

@immutable
abstract class GetStatisticsOverviewState {}

class GetStatisticsOverviewInitial extends GetStatisticsOverviewState {}

class LoadingGetStatisticsOverview extends GetStatisticsOverviewState {}

class SuccessGetStatisticsOverview extends GetStatisticsOverviewState {
  final StatisticsOverviewResponseModel response;

  SuccessGetStatisticsOverview({required this.response});
}

class ExceptionGetStatisticsOverview extends GetStatisticsOverviewState {
  final String message;

  ExceptionGetStatisticsOverview({required this.message});
}

class ForbiddenGetStatisticsOverview extends GetStatisticsOverviewState {
  final String message;

  ForbiddenGetStatisticsOverview({required this.message});
}

