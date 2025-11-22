part of 'get_statistics_buffet_bloc.dart';

@immutable
abstract class GetStatisticsBuffetState {}

class GetStatisticsBuffetInitial extends GetStatisticsBuffetState {}

class LoadingGetStatisticsBuffet extends GetStatisticsBuffetState {}

class SuccessGetStatisticsBuffet extends GetStatisticsBuffetState {
  final StatisticsBuffetResponseModel response;

  SuccessGetStatisticsBuffet({required this.response});
}

class ExceptionGetStatisticsBuffet extends GetStatisticsBuffetState {
  final String message;

  ExceptionGetStatisticsBuffet({required this.message});
}

class ForbiddenGetStatisticsBuffet extends GetStatisticsBuffetState {
  final String message;

  ForbiddenGetStatisticsBuffet({required this.message});
}

