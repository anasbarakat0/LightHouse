part of 'get_premium_user_by_name_bloc.dart';

@immutable
abstract class GetPremiumUserByNameEvent {}

class GetPremiumUserByName extends GetPremiumUserByNameEvent {
  final String name;
  GetPremiumUserByName({required this.name});
}
