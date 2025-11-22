part of 'get_users_by_name_bloc.dart';

@immutable
abstract class GetUsersByNameEvent {}

class GetUsersByName extends GetUsersByNameEvent {
  final String name;
  GetUsersByName({required this.name});
}

class ResetUsersByNameSearch extends GetUsersByNameEvent {}
