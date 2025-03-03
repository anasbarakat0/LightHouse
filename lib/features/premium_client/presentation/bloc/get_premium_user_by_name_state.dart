part of 'get_premium_user_by_name_bloc.dart';

@immutable
abstract class GetPremiumUserByNameState {}

class GetPremiumUserByNameInitial extends GetPremiumUserByNameState {}

class SuccessGettingPremiumUserByName extends GetPremiumUserByNameState {
  final GetPremiumUserByNameResponse response;
  SuccessGettingPremiumUserByName({required this.response});
}

class ExceptionGettingPremiumUserByName extends GetPremiumUserByNameState {
  final String message;
  ExceptionGettingPremiumUserByName({required this.message});
}

class ForbiddenGettingPremiumUserByName extends GetPremiumUserByNameState {
  final String message;
  ForbiddenGettingPremiumUserByName({required this.message});
}

class LoadingGettingPremiumUserByName extends GetPremiumUserByNameState {}
