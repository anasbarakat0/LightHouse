import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_sessions_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_sessions_usecase.dart';
import 'package:meta/meta.dart';

part 'get_statistics_sessions_event.dart';
part 'get_statistics_sessions_state.dart';

class GetStatisticsSessionsBloc
    extends Bloc<GetStatisticsSessionsEvent, GetStatisticsSessionsState> {
  final GetStatisticsSessionsUsecase getStatisticsSessionsUsecase;

  GetStatisticsSessionsBloc({required this.getStatisticsSessionsUsecase})
      : super(GetStatisticsSessionsInitial()) {
    on<GetStatisticsSessions>((event, emit) async {
      emit(LoadingGetStatisticsSessions());
      var data = await getStatisticsSessionsUsecase.call(
        from: event.from,
        to: event.to,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetStatisticsSessions(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetStatisticsSessions(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetStatisticsSessions(message: failure.message));
            break;
          default:
            emit(ExceptionGetStatisticsSessions(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetStatisticsSessions(response: response));
      });
    });
  }
}

