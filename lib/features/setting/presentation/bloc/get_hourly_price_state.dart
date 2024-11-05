// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_hourly_price_bloc.dart';

@immutable
abstract class GetHourlyPriceState {}

class GetHourlyPriceInitial extends GetHourlyPriceState {}

class SuccessGettingPrice extends GetHourlyPriceState {
  final double price;
  SuccessGettingPrice({
    required this.price,
  });
}

class ErrorGettingPrice extends GetHourlyPriceState {
  final String message;
  ErrorGettingPrice({required this.message});
}

class OfflineGettingPrice extends GetHourlyPriceState {
  final String message;
  OfflineGettingPrice({
    required this.message,
  });
}

class Forbidden extends GetHourlyPriceState{
  late final String message;
}

class LoadingGettingPrice extends GetHourlyPriceState {}
