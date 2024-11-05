// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_premium_clients_bloc.dart';

@immutable
abstract class GetPremiumClientsState {}

class GetPremiumClientsInitial extends GetPremiumClientsState {}

class SuccessFetchingClients extends GetPremiumClientsState {
  final GetAllPremiumclientResponseModel  responseModel;
  SuccessFetchingClients({
    required this.responseModel,
  });
}

class OfflineFailureState extends GetPremiumClientsState {
  final String message;
  OfflineFailureState({
    required this.message,
  });
}

class ExceptionFetchingClients extends GetPremiumClientsState {
  final String message;
  ExceptionFetchingClients({
    required this.message,
  });
}

class LoadingFetchingClients extends GetPremiumClientsState{}