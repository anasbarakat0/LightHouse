part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class LoadingChangePassword extends ChangePasswordState {}

class SuccessChangePassword extends ChangePasswordState {
  final String message;

  SuccessChangePassword({required this.message});
}

class ExceptionChangePassword extends ChangePasswordState {
  final String message;

  ExceptionChangePassword({required this.message});
}

class OfflineFailureChangePassword extends ChangePasswordState {
  final String message;

  OfflineFailureChangePassword({required this.message});
}

