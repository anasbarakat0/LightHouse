// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_hourly_price_bloc.dart';

@immutable
abstract class EditHourlyPriceEvent {}

class EditHourlyPrice extends EditHourlyPriceEvent {
  final double hourlyPrice;
  EditHourlyPrice({
    required this.hourlyPrice,
  });
}
