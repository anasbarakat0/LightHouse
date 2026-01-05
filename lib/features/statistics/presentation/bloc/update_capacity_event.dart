part of 'update_capacity_bloc.dart';

@immutable
abstract class UpdateCapacityEvent {}

class UpdateCapacity extends UpdateCapacityEvent {
  final int capacity;

  UpdateCapacity({required this.capacity});
}


