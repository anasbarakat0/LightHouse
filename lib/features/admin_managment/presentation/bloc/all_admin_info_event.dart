// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'all_admin_info_bloc.dart';

@immutable
abstract class AllAdminInfoEvent {}

class GetAdmins extends AllAdminInfoEvent {
  final int page;
  final int size;
  GetAdmins({
    required this.page,
    required this.size,
  });
}
