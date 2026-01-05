part of 'get_occupancy_bloc.dart';

@immutable
abstract class GetOccupancyState {}

class GetOccupancyInitial extends GetOccupancyState {}

class LoadingOccupancy extends GetOccupancyState {}

class SuccessOccupancy extends GetOccupancyState {
  final int onGround;
  final int visits;
  final int capacity;

  SuccessOccupancy({
    required this.onGround,
    required this.visits,
    required this.capacity,
  });
}

class ErrorOccupancy extends GetOccupancyState {
  final String message;

  ErrorOccupancy({required this.message});
}

class OfflineOccupancy extends GetOccupancyState {
  final String message;

  OfflineOccupancy({required this.message});
}


