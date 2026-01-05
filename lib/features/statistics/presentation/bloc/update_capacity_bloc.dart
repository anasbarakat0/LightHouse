import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/domain/usecase/update_capacity_usecase.dart';
import 'package:meta/meta.dart';

part 'update_capacity_event.dart';
part 'update_capacity_state.dart';

class UpdateCapacityBloc extends Bloc<UpdateCapacityEvent, UpdateCapacityState> {
  final UpdateCapacityUsecase updateCapacityUsecase;

  UpdateCapacityBloc({required this.updateCapacityUsecase})
      : super(UpdateCapacityInitial()) {
    on<UpdateCapacity>((event, emit) async {
      emit(LoadingCapacity());
      var data = await updateCapacityUsecase.call(event.capacity);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ErrorCapacity(message: failure.message));
            break;
          case OfflineFailure():
            emit(OfflineCapacity(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenCapacity(message: failure.message));
            break;
          default:
            emit(ErrorCapacity(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessCapacity(
          capacity: response.body.capacity,
          message: response.message,
        ));
      });
    });
  }
}


