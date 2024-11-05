// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_premium_client_bloc.dart';

@immutable
abstract class AddPremiumClientState {}

class AddPremiumClientInitial extends AddPremiumClientState {}

class ClientAdded extends AddPremiumClientState {
  final NewPremiumClientResponseModel response;
  ClientAdded({
    required this.response,
  });
}

class ExceptionAddedClient extends AddPremiumClientState {
  final String message;
  ExceptionAddedClient({
    required this.message,
  });
}

class ForbiddenAdded extends AddPremiumClientState {
  final String message;
  ForbiddenAdded({
    required this.message,
  });
}

class LoadingAddingPremiumClient extends AddPremiumClientState{}