part of 'get_all_coupons_bloc.dart';

@immutable
abstract class GetAllCouponsEvent {}

class GetAllCoupons extends GetAllCouponsEvent {
  final int? page;
  final int? size;
  final bool? active;
  final String? discountType;
  final String? appliesTo;
  final String? codeSubstring;
  final String? sort;

  GetAllCoupons({
    this.page,
    this.size,
    this.active,
    this.discountType,
    this.appliesTo,
    this.codeSubstring,
    this.sort,
  });
}

