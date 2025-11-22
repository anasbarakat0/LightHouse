part of 'deactivate_coupon_bloc.dart';

@immutable
abstract class DeactivateCouponEvent {}

class DeactivateCoupon extends DeactivateCouponEvent {
  final String couponId;

  DeactivateCoupon({required this.couponId});
}

