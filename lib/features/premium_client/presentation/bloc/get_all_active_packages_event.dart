part of 'get_all_active_packages_bloc.dart';

@immutable
abstract class GetAllActivePackagesEvent {}

class GetAllActivePackages extends GetAllActivePackagesEvent {
  final int page;
  final int size;
  GetAllActivePackages({required this.page, required this.size});
}
