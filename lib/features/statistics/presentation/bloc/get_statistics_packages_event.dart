part of 'get_statistics_packages_bloc.dart';

@immutable
abstract class GetStatisticsPackagesEvent {}

class GetStatisticsPackages extends GetStatisticsPackagesEvent {
  final String? from;
  final String? to;

  GetStatisticsPackages({
    this.from,
    this.to,
  });
}

