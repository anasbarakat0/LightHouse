part of 'update_premium_client_bloc.dart';

@immutable
abstract class UpdatePremiumClientEvent {}

class UpdatePremiumClient extends UpdatePremiumClientEvent {
  final String userId;
  final UpdatePremiumClientModel client;

  UpdatePremiumClient({
    required this.userId,
    required this.client,
  });
}

