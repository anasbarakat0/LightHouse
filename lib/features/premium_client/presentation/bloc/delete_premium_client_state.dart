part of 'delete_premium_client_bloc.dart';

@immutable
abstract class DeletePremiumClientState {}

class DeletePremiumClientInitial extends DeletePremiumClientState {}

class LoadingDeletePremiumClient extends DeletePremiumClientState {}

class SuccessDeletePremiumClient extends DeletePremiumClientState {
  final String message;

  SuccessDeletePremiumClient({required this.message});
}

class ExceptionDeletePremiumClient extends DeletePremiumClientState {
  final String message;

  ExceptionDeletePremiumClient({required this.message});
}

class OfflineFailureDeletePremiumClient extends DeletePremiumClientState {
  final String message;

  OfflineFailureDeletePremiumClient({required this.message});
}

