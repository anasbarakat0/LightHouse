// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_premium_clients_bloc.dart';

@immutable
abstract class GetPremiumClientsEvent {}

class GetPremiumClients extends GetPremiumClientsEvent {
  final int page;
  final int size;
  GetPremiumClients({
    required this.page,
    required this.size,
  });
}
