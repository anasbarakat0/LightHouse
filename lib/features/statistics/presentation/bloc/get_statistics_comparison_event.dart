part of 'get_statistics_comparison_bloc.dart';

@immutable
abstract class GetStatisticsComparisonEvent {}

class GetStatisticsComparison extends GetStatisticsComparisonEvent {
  final String currentFrom;
  final String currentTo;
  final String previousFrom;
  final String previousTo;

  GetStatisticsComparison({
    required this.currentFrom,
    required this.currentTo,
    required this.previousFrom,
    required this.previousTo,
  });
}

