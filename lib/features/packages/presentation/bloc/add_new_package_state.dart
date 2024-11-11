part of 'add_new_package_bloc.dart';

@immutable
abstract class AddNewPackageState {}

class AddNewPackageInitial extends AddNewPackageState {}

class PackageAdded extends AddNewPackageState {
  final EditPackageInfoResponseModel editPackageInfoResponseModel;
  PackageAdded({
    required this.editPackageInfoResponseModel,
  });
}

class ExceptionAddPackage extends AddNewPackageState {
  final String message;
  ExceptionAddPackage({
    required this.message,
  });
}

class ForbiddenAddPackage extends AddNewPackageState {
  final String message;
  ForbiddenAddPackage({
    required this.message,
  });
}

class LoadingAddPackage extends AddNewPackageState {}
