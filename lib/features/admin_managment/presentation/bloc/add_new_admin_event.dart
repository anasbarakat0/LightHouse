// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_new_admin_bloc.dart';

@immutable
abstract class AddNewAdminEvent {}

class AddAdmin extends AddNewAdminEvent {
  final NewAdminModel admin;
  AddAdmin({
    required this.admin,
  });
}
