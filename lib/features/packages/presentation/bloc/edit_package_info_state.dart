part of 'edit_package_info_bloc.dart';

@immutable
abstract class EditPackageInfoState {}

class EditPackageInfoInitial extends EditPackageInfoState {}

class PackageEdited extends EditPackageInfoState {
  final EditPackageInfoResponseModel editPackageInfoResponseModel;
  PackageEdited({
    required this.editPackageInfoResponseModel,
  });
}

class ExceptionEditPackage extends EditPackageInfoState {
  final String message;
  ExceptionEditPackage({
    required this.message,
  });
}

class ForbiddenEditPackage extends EditPackageInfoState {
  final String message;
  ForbiddenEditPackage({
    required this.message,
  });
}

class LoadingEditPackage extends EditPackageInfoState {}
