part of 'subscribe_user_to_package_bloc.dart';

@immutable
abstract class SubscribeUserToPackageEvent {}

class SubscribeUserToPackage extends SubscribeUserToPackageEvent {
  final String packageId;
  final String userId;
  SubscribeUserToPackage({
    required this.packageId,
    required this.userId,
  });
}
