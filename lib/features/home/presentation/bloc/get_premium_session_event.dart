// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_premium_session_bloc.dart';

@immutable
abstract class GetPremiumSessionEvent {}

class GetPremiumSession extends GetPremiumSessionEvent {
  final String id;
  GetPremiumSession({
    required this.id,
  });
}
