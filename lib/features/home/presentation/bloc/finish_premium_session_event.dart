part of 'finish_premium_session_bloc.dart';

@immutable
abstract class FinishPremiumSessionEvent {}

class FinishPreSession extends FinishPremiumSessionEvent {
  final String id;
  FinishPreSession({
    required this.id,
  });
}
