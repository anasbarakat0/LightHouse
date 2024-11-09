// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_all_active_packages_bloc.dart';

@immutable
sealed class GetAllActivePackagesEvent {}

class GetAllActivePackages extends GetAllActivePackagesEvent {
  final int page;
  final int size;
  GetAllActivePackages({
    required this.page,
    required this.size,
  });
}
