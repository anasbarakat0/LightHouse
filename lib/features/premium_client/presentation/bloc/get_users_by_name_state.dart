part of 'get_users_by_name_bloc.dart';

@immutable
abstract class GetUsersByNameState {}

class GetUsersByNameInitial extends GetUsersByNameState {}

class LoadingGettingUsersByName extends GetUsersByNameState {}

class SuccessGettingUsersByName extends GetUsersByNameState {
  final GetUsersByNameResponseModel response;
  SuccessGettingUsersByName({required this.response});
}

class ExceptionGettingUsersByName extends GetUsersByNameState {
  final String message;
  ExceptionGettingUsersByName({required this.message});
}

class ForbiddenGettingUsersByName extends GetUsersByNameState {
  final String message;
  ForbiddenGettingUsersByName({required this.message});
}

class NoUsersFound extends GetUsersByNameState {
  final String message;
  NoUsersFound({required this.message});
}
