// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseModel data;
  LoginSuccess({
    required this.data,
  });
}

class LoginFailed extends LoginState{
  final String message;

  LoginFailed(this.message);
}

class LoginLoading extends LoginState{}