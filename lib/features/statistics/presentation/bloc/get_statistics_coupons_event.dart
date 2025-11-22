part of 'get_statistics_coupons_bloc.dart';

@immutable
abstract class GetStatisticsCouponsEvent {}

class GetStatisticsCoupons extends GetStatisticsCouponsEvent {
  final String? from;
  final String? to;
  final int? top;

  GetStatisticsCoupons({
    this.from,
    this.to,
    this.top,
  });
}

