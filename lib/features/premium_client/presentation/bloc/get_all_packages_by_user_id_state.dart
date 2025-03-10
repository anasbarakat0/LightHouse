// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_all_packages_by_user_id_bloc.dart';

@immutable
abstract class GetAllPackagesByUserIdState {}

class GetAllPackagesByUserIdInitial extends GetAllPackagesByUserIdState {}

class LoadingFetchingPackages extends GetAllPackagesByUserIdState {}

class NoPackages extends GetAllPackagesByUserIdState {
  final String message;
  NoPackages({
    required this.message,
  });

}

class SuccessFetchingPackages extends GetAllPackagesByUserIdState {
  final GetAllPackagesByUserIdResponse response;
  SuccessFetchingPackages({required this.response});
}

class ExceptionFetchingPackages extends GetAllPackagesByUserIdState {
  final String message;
  ExceptionFetchingPackages({required this.message});
}

class OfflineFailureState extends GetAllPackagesByUserIdState {
  final String message;
  OfflineFailureState({required this.message});
}
