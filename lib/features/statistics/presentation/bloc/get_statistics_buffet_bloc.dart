import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_buffet_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_buffet_usecase.dart';
import 'package:meta/meta.dart';

part 'get_statistics_buffet_event.dart';
part 'get_statistics_buffet_state.dart';

class GetStatisticsBuffetBloc
    extends Bloc<GetStatisticsBuffetEvent, GetStatisticsBuffetState> {
  final GetStatisticsBuffetUsecase getStatisticsBuffetUsecase;

  GetStatisticsBuffetBloc({required this.getStatisticsBuffetUsecase})
      : super(GetStatisticsBuffetInitial()) {
    on<GetStatisticsBuffet>((event, emit) async {
      emit(LoadingGetStatisticsBuffet());
      var data = await getStatisticsBuffetUsecase.call(
        from: event.from,
        to: event.to,
        top: event.top,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetStatisticsBuffet(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetStatisticsBuffet(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetStatisticsBuffet(message: failure.message));
            break;
          default:
            emit(ExceptionGetStatisticsBuffet(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetStatisticsBuffet(response: response));
      });
    });
  }
}

