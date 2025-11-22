part of 'get_statistics_users_bloc.dart';

@immutable
abstract class GetStatisticsUsersState {}

class GetStatisticsUsersInitial extends GetStatisticsUsersState {}

class LoadingGetStatisticsUsers extends GetStatisticsUsersState {}

class SuccessGetStatisticsUsers extends GetStatisticsUsersState {
  final StatisticsUsersResponseModel response;

  SuccessGetStatisticsUsers({required this.response});
}

class ExceptionGetStatisticsUsers extends GetStatisticsUsersState {
  final String message;

  ExceptionGetStatisticsUsers({required this.message});
}

class ForbiddenGetStatisticsUsers extends GetStatisticsUsersState {
  final String message;

  ForbiddenGetStatisticsUsers({required this.message});
}

