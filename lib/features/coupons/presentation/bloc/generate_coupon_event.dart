part of 'generate_coupon_bloc.dart';

@immutable
abstract class GenerateCouponEvent {}

class GenerateCoupon extends GenerateCouponEvent {
  final GenerateCouponRequestModel request;

  GenerateCoupon({required this.request});
}

