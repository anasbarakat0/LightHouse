part of 'delete_premium_client_bloc.dart';

@immutable
abstract class DeletePremiumClientEvent {}

class DeletePremiumClient extends DeletePremiumClientEvent {
  final String userId;

  DeletePremiumClient({
    required this.userId,
  });
}

