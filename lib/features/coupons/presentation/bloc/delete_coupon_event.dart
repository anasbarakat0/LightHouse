part of 'delete_coupon_bloc.dart';

@immutable
abstract class DeleteCouponEvent {}

class DeleteCoupon extends DeleteCouponEvent {
  final String couponId;

  DeleteCoupon({required this.couponId});
}

