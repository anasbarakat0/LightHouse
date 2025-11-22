part of 'generate_coupon_bloc.dart';

@immutable
abstract class GenerateCouponState {}

class GenerateCouponInitial extends GenerateCouponState {}

class LoadingGenerateCoupon extends GenerateCouponState {}

class SuccessGenerateCoupon extends GenerateCouponState {
  final GenerateCouponResponseModel response;

  SuccessGenerateCoupon({required this.response});
}

class ExceptionGenerateCoupon extends GenerateCouponState {
  final String message;

  ExceptionGenerateCoupon({required this.message});
}

class OfflineFailureGenerateCoupon extends GenerateCouponState {
  final String message;

  OfflineFailureGenerateCoupon({required this.message});
}

