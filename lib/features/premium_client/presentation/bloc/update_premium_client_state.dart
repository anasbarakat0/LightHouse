part of 'update_premium_client_bloc.dart';

@immutable
abstract class UpdatePremiumClientState {}

class UpdatePremiumClientInitial extends UpdatePremiumClientState {}

class LoadingUpdatePremiumClient extends UpdatePremiumClientState {}

class SuccessUpdatePremiumClient extends UpdatePremiumClientState {
  final NewPremiumClientResponseModel response;

  SuccessUpdatePremiumClient({required this.response});
}

class ExceptionUpdatePremiumClient extends UpdatePremiumClientState {
  final String message;

  ExceptionUpdatePremiumClient({required this.message});
}

class OfflineFailureUpdatePremiumClient extends UpdatePremiumClientState {
  final String message;

  OfflineFailureUpdatePremiumClient({required this.message});
}

