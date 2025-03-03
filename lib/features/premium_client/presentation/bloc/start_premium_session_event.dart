// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'start_premium_session_bloc.dart';

@immutable
abstract class StartPremiumSessionEvent {}

class StartPreSession extends StartPremiumSessionEvent {
  final String id;
  StartPreSession({
    required this.id,
  });
}