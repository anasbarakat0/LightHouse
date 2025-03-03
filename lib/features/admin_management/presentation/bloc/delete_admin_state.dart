// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_admin_bloc.dart';

@immutable
abstract class DeleteAdminState {}

class DeleteAdminInitial extends DeleteAdminState {}

class AdminDeleted extends DeleteAdminState {
  final SuccessResponseModel response;
  AdminDeleted({
    required this.response,
  });
}

class ExceptionDeleteAdmin extends DeleteAdminState {
  final String message;
  ExceptionDeleteAdmin({
    required this.message,
  });
}

class ForbiddenDeleteState extends DeleteAdminState {
  final String message;
  ForbiddenDeleteState({
    required this.message,
  });
}

class LoadingDeleting extends DeleteAdminState {}
