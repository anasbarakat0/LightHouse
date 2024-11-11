// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_package_info_bloc.dart';

@immutable
abstract class EditPackageInfoEvent {}

class EditPackageInfo extends EditPackageInfoEvent {
  final String id;
  final PackageModel package;
  EditPackageInfo({
    required this.id,
    required this.package,
  });
}
