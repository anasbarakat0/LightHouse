part of 'get_all_coupons_bloc.dart';

@immutable
abstract class GetAllCouponsState {}

class GetAllCouponsInitial extends GetAllCouponsState {}

class LoadingGetAllCoupons extends GetAllCouponsState {}

class SuccessGetAllCoupons extends GetAllCouponsState {
  final GetAllCouponsResponseModel response;

  SuccessGetAllCoupons({required this.response});
}

class NoCouponsToShow extends GetAllCouponsState {
  final String message;

  NoCouponsToShow({required this.message});
}

class ExceptionGetAllCoupons extends GetAllCouponsState {
  final String message;

  ExceptionGetAllCoupons({required this.message});
}

class OfflineFailureGetAllCoupons extends GetAllCouponsState {
  final String message;

  OfflineFailureGetAllCoupons({required this.message});
}

