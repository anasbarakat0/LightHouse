// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_sessions_by_user_id_bloc.dart';

@immutable
abstract class GetSessionsByUserIdState {}

class GetSessionsByUserIdInitial extends GetSessionsByUserIdState {}

class LoadingFetchingSessions extends GetSessionsByUserIdState {}

class NoSessions extends GetSessionsByUserIdState {
  final String message;
  NoSessions({
    required this.message,
  });
}

class SuccessFetchingSessions extends GetSessionsByUserIdState {
  final GetSessionsByUserIdResponseModel response;
  SuccessFetchingSessions({required this.response});
}

class ExceptionFetchingSessions extends GetSessionsByUserIdState {
  final String message;
  ExceptionFetchingSessions({required this.message});
}

class OfflineFailureSessionsState extends GetSessionsByUserIdState {
  final String message;
  OfflineFailureSessionsState({required this.message});
}


