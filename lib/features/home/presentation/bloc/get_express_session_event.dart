part of 'get_express_session_bloc.dart';

@immutable
abstract class GetExpressSessionEvent {}

class GetExpressSession extends GetExpressSessionEvent {
  final String id;
  GetExpressSession({
    required this.id,
  });
}
