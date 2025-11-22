import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_real_time_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_real_time_usecase.dart';
import 'package:meta/meta.dart';

part 'get_statistics_real_time_event.dart';
part 'get_statistics_real_time_state.dart';

class GetStatisticsRealTimeBloc
    extends Bloc<GetStatisticsRealTimeEvent, GetStatisticsRealTimeState> {
  final GetStatisticsRealTimeUsecase getStatisticsRealTimeUsecase;

  GetStatisticsRealTimeBloc({required this.getStatisticsRealTimeUsecase})
      : super(GetStatisticsRealTimeInitial()) {
    on<GetStatisticsRealTime>((event, emit) async {
      emit(LoadingGetStatisticsRealTime());
      var data = await getStatisticsRealTimeUsecase.call();
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetStatisticsRealTime(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetStatisticsRealTime(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetStatisticsRealTime(message: failure.message));
            break;
          default:
            emit(ExceptionGetStatisticsRealTime(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetStatisticsRealTime(response: response));
      });
    });
  }
}

