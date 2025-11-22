part of 'deactivate_coupon_bloc.dart';

@immutable
abstract class DeactivateCouponState {}

class DeactivateCouponInitial extends DeactivateCouponState {}

class LoadingDeactivateCoupon extends DeactivateCouponState {}

class SuccessDeactivateCoupon extends DeactivateCouponState {
  final DeactivateCouponResponseModel response;

  SuccessDeactivateCoupon({required this.response});
}

class ExceptionDeactivateCoupon extends DeactivateCouponState {
  final String message;

  ExceptionDeactivateCoupon({required this.message});
}

class OfflineFailureDeactivateCoupon extends DeactivateCouponState {
  final String message;

  OfflineFailureDeactivateCoupon({required this.message});
}

