part of 'get_statistics_revenue_bloc.dart';

@immutable
abstract class GetStatisticsRevenueState {}

class GetStatisticsRevenueInitial extends GetStatisticsRevenueState {}

class LoadingGetStatisticsRevenue extends GetStatisticsRevenueState {}

class SuccessGetStatisticsRevenue extends GetStatisticsRevenueState {
  final StatisticsRevenueResponseModel response;

  SuccessGetStatisticsRevenue({required this.response});
}

class ExceptionGetStatisticsRevenue extends GetStatisticsRevenueState {
  final String message;

  ExceptionGetStatisticsRevenue({required this.message});
}

class ForbiddenGetStatisticsRevenue extends GetStatisticsRevenueState {
  final String message;

  ForbiddenGetStatisticsRevenue({required this.message});
}

