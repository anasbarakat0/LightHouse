part of 'delete_coupon_bloc.dart';

@immutable
abstract class DeleteCouponState {}

class DeleteCouponInitial extends DeleteCouponState {}

class LoadingDeleteCoupon extends DeleteCouponState {}

class SuccessDeleteCoupon extends DeleteCouponState {
  final DeleteCouponResponseModel response;

  SuccessDeleteCoupon({required this.response});
}

class ExceptionDeleteCoupon extends DeleteCouponState {
  final String message;

  ExceptionDeleteCoupon({required this.message});
}

class OfflineFailureDeleteCoupon extends DeleteCouponState {
  final String message;

  OfflineFailureDeleteCoupon({required this.message});
}

