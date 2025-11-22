part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class ChangePassword extends ChangePasswordEvent {
  final ChangePasswordModel changePasswordModel;

  ChangePassword({
    required this.changePasswordModel,
  });
}

