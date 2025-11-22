part of 'get_statistics_comparison_bloc.dart';

@immutable
abstract class GetStatisticsComparisonState {}

class GetStatisticsComparisonInitial extends GetStatisticsComparisonState {}

class LoadingGetStatisticsComparison extends GetStatisticsComparisonState {}

class SuccessGetStatisticsComparison extends GetStatisticsComparisonState {
  final StatisticsComparisonResponseModel response;

  SuccessGetStatisticsComparison({required this.response});
}

class ExceptionGetStatisticsComparison extends GetStatisticsComparisonState {
  final String message;

  ExceptionGetStatisticsComparison({required this.message});
}

class ForbiddenGetStatisticsComparison extends GetStatisticsComparisonState {
  final String message;

  ForbiddenGetStatisticsComparison({required this.message});
}

