// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_all_active_packages_bloc.dart';

@immutable
abstract class GetAllActivePackagesState {}

class GetAllActivePackagesInitial extends GetAllActivePackagesState {}

class LoadingFetchingActivePackages extends GetAllActivePackagesState {}

class NoActivePackages extends GetAllActivePackagesState {
  final String message;
  NoActivePackages({
    required this.message,
  });
}

class SuccessFetchingActivePackages extends GetAllActivePackagesState {
  final GetAllActivePackagesResponse response;
  SuccessFetchingActivePackages({required this.response});
}

class ExceptionFetchingActivePackages extends GetAllActivePackagesState {
  final String message;
  ExceptionFetchingActivePackages({required this.message});
}

class OfflineFailureActivePackagesState extends GetAllActivePackagesState {
  final String message;
  OfflineFailureActivePackagesState({required this.message});
}
