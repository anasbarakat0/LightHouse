part of 'add_new_admin_bloc.dart';

@immutable
abstract class AddNewAdminState {}

class AddNewAdminInitial extends AddNewAdminState {}

class AdminCreated extends AddNewAdminState {
  final NewAdminResponseModel response;
  AdminCreated({
    required this.response,
  });
}

class ErrorCreatingAdmin extends AddNewAdminState {
  final List<String> messages;
  ErrorCreatingAdmin({
    required this.messages,
  });
}

class LoadingAddAdmin extends AddNewAdminState{}