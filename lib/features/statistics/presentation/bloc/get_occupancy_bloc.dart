import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/occupancy_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_occupancy_usecase.dart';
import 'package:meta/meta.dart';

part 'get_occupancy_event.dart';
part 'get_occupancy_state.dart';

class GetOccupancyBloc extends Bloc<GetOccupancyEvent, GetOccupancyState> {
  final GetOccupancyUsecase getOccupancyUsecase;

  GetOccupancyBloc({required this.getOccupancyUsecase})
      : super(GetOccupancyInitial()) {
    on<GetOccupancy>((event, emit) async {
      emit(LoadingOccupancy());
      var data = await getOccupancyUsecase.call();
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ErrorOccupancy(message: failure.message));
            break;
          case OfflineFailure():
            emit(OfflineOccupancy(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ErrorOccupancy(message: failure.message));
            break;
          default:
            emit(ErrorOccupancy(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessOccupancy(
          onGround: response.body.onGround,
          visits: response.body.visits,
          capacity: response.body.capacity,
        ));
      });
    });
  }
}


