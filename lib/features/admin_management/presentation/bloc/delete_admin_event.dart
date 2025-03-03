// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_admin_bloc.dart';

@immutable
abstract class DeleteAdminEvent {}

class DeleteAdmin extends DeleteAdminEvent {
  final String id;
  DeleteAdmin({
    required this.id,
  });
}
