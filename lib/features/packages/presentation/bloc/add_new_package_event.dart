// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_new_package_bloc.dart';

@immutable
abstract class AddNewPackageEvent {}

class AddPackage extends AddNewPackageEvent {
  final PackageModel package;
  AddPackage({
    required this.package,
  });
}
