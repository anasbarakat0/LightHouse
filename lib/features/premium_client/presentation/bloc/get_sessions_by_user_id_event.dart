part of 'get_sessions_by_user_id_bloc.dart';

@immutable
abstract class GetSessionsByUserIdEvent {}

class GetSessionsByUserId extends GetSessionsByUserIdEvent {
  final String userId;
  final int page;
  final int size;
  GetSessionsByUserId({
    required this.userId,
    required this.page,
    required this.size,
  });
}


