// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'all_admin_info_bloc.dart';

@immutable
abstract class AllAdminInfoState {}

class AllAdminInfoInitial extends AllAdminInfoState {}

class SucessFetchingAdmins extends AllAdminInfoState {
  final AllAdminInfoResponse allAdminInfoResponse;

  SucessFetchingAdmins(this.allAdminInfoResponse);
}

class ErrorFetchingAdmins extends AllAdminInfoState {
  final String message;

  ErrorFetchingAdmins(this.message);
}

class ForbiddenFetching extends AllAdminInfoState {
  final String message;
  ForbiddenFetching({
    required this.message,
  });
}

class LoadingFetchingAdmins extends AllAdminInfoState {}
