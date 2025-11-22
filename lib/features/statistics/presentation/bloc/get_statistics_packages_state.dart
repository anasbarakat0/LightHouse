part of 'get_statistics_packages_bloc.dart';

@immutable
abstract class GetStatisticsPackagesState {}

class GetStatisticsPackagesInitial extends GetStatisticsPackagesState {}

class LoadingGetStatisticsPackages extends GetStatisticsPackagesState {}

class SuccessGetStatisticsPackages extends GetStatisticsPackagesState {
  final StatisticsPackagesResponseModel response;

  SuccessGetStatisticsPackages({required this.response});
}

class ExceptionGetStatisticsPackages extends GetStatisticsPackagesState {
  final String message;

  ExceptionGetStatisticsPackages({required this.message});
}

class ForbiddenGetStatisticsPackages extends GetStatisticsPackagesState {
  final String message;

  ForbiddenGetStatisticsPackages({required this.message});
}

