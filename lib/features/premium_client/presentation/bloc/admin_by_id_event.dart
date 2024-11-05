// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'admin_by_id_bloc.dart';

@immutable
abstract class AdminByIdEvent {}

class GetAdminById extends AdminByIdEvent {
  final String id;
  GetAdminById({
    required this.id,
  });
}
