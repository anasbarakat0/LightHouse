// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'start_express_session_bloc.dart';

@immutable
abstract class StartExpressSessionEvent {}

class StartExpressSession extends StartExpressSessionEvent {
  final String fullName;
  StartExpressSession({
    required this.fullName,
  });
}
