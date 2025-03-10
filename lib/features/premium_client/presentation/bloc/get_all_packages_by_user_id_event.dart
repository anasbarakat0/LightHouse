part of 'get_all_packages_by_user_id_bloc.dart';

@immutable
abstract class GetAllPackagesByUserIdEvent {}

class GetAllPackagesByUserId extends GetAllPackagesByUserIdEvent {
  final String userId;
  final int page;
  final int size;
  GetAllPackagesByUserId({
    required this.userId,
    required this.page,
    required this.size,
  });
}
