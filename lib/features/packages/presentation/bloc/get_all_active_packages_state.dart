// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_all_active_packages_bloc.dart';

@immutable
sealed class GetAllActivePackagesState {}

final class GetAllActivePackagesInitial extends GetAllActivePackagesState {}

class NoPackagesToShow extends GetAllActivePackagesState {
  final NoActivePackages noActivePackages;
  NoPackagesToShow({
    required this.noActivePackages,
  });
}

class ShowingAllPackages extends GetAllActivePackagesState {
  final ActivePackages activePackages;
  ShowingAllPackages({
    required this.activePackages,
  });
}

class ExceptionWhilePackages extends GetAllActivePackagesState {
  final String message;
  ExceptionWhilePackages({
    required this.message,
  });
}

class ForbiddenShowingPackage extends GetAllActivePackagesState {
  final String message;
  ForbiddenShowingPackage({
    required this.message,
  });
}

class LoadingShowingPackage extends GetAllActivePackagesState {}
