// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_hourly_price_bloc.dart';

@immutable
abstract class EditHourlyPriceState {}

class EditHourlyPriceInitial extends EditHourlyPriceState {}


class SuccessEditingPrice extends EditHourlyPriceState {
  final double price;
  final String message;
  SuccessEditingPrice({
    required this.price,
    required this.message,
  });
}

class ErrorEditingPrice extends EditHourlyPriceState {
  final String message;
  ErrorEditingPrice({required this.message});
}

class OfflineEditingPrice extends EditHourlyPriceState {
  final String message;
  OfflineEditingPrice({
    required this.message,
  });
}

class ForbiddenEditing extends EditHourlyPriceState {
  late final String message;
}

class LoadingEditingPrice extends EditHourlyPriceState {}
