part of 'update_capacity_bloc.dart';

@immutable
abstract class UpdateCapacityState {}

class UpdateCapacityInitial extends UpdateCapacityState {}

class LoadingCapacity extends UpdateCapacityState {}

class SuccessCapacity extends UpdateCapacityState {
  final int capacity;
  final String message;

  SuccessCapacity({
    required this.capacity,
    required this.message,
  });
}

class ErrorCapacity extends UpdateCapacityState {
  final String message;

  ErrorCapacity({required this.message});
}

class OfflineCapacity extends UpdateCapacityState {
  final String message;

  OfflineCapacity({required this.message});
}

class ForbiddenCapacity extends UpdateCapacityState {
  final String message;

  ForbiddenCapacity({required this.message});
}


