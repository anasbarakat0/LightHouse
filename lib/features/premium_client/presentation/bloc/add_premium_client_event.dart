// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_premium_client_bloc.dart';

@immutable
abstract class AddPremiumClientEvent {}

class AddPremiumClient extends AddPremiumClientEvent {
  final PremiumClient client;
  AddPremiumClient({
    required this.client,
  });
}
