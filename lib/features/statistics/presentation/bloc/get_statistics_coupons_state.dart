part of 'get_statistics_coupons_bloc.dart';

@immutable
abstract class GetStatisticsCouponsState {}

class GetStatisticsCouponsInitial extends GetStatisticsCouponsState {}

class LoadingGetStatisticsCoupons extends GetStatisticsCouponsState {}

class SuccessGetStatisticsCoupons extends GetStatisticsCouponsState {
  final StatisticsCouponsResponseModel response;

  SuccessGetStatisticsCoupons({required this.response});
}

class ExceptionGetStatisticsCoupons extends GetStatisticsCouponsState {
  final String message;

  ExceptionGetStatisticsCoupons({required this.message});
}

class ForbiddenGetStatisticsCoupons extends GetStatisticsCouponsState {
  final String message;

  ForbiddenGetStatisticsCoupons({required this.message});
}

