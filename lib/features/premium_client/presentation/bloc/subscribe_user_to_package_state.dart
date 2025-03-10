part of 'subscribe_user_to_package_bloc.dart';

@immutable
abstract class SubscribeUserToPackageState {}

class SubscribeUserToPackageInitial extends SubscribeUserToPackageState {}

class LoadingSubscribeUserToPackage extends SubscribeUserToPackageState {}

class SuccessSubscribeUserToPackage extends SubscribeUserToPackageState {
  final SubscribeUserToPackageResponse response;
  SuccessSubscribeUserToPackage({required this.response});
}

class ExceptionSubscribeUserToPackage extends SubscribeUserToPackageState {
  final String message;
  ExceptionSubscribeUserToPackage({required this.message});
}

class OfflineFailureSubscribeUserToPackage extends SubscribeUserToPackageState {
  final String message;
  OfflineFailureSubscribeUserToPackage({required this.message});
}
  