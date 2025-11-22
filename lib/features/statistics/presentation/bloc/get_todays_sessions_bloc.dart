import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/todays_sessions_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_todays_sessions_usecase.dart';
import 'package:meta/meta.dart';

part 'get_todays_sessions_event.dart';
part 'get_todays_sessions_state.dart';

class GetTodaysSessionsBloc
    extends Bloc<GetTodaysSessionsEvent, GetTodaysSessionsState> {
  final GetTodaysSessionsUsecase getTodaysSessionsUsecase;

  GetTodaysSessionsBloc(this.getTodaysSessionsUsecase)
      : super(GetTodaysSessionsInitial()) {
    on<GetTodaysSessions>((event, emit) async {
      emit(LoadingGetTodaysSessions());
      final result =
          await getTodaysSessionsUsecase.call(event.page, event.size);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureGetTodaysSessions(message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionGetTodaysSessions(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionGetTodaysSessions(message: failure.message));
          } else if (failure is NoDataFailure) {
            emit(NoTodaysSessions(message: failure.message));
          } else {
            emit(ExceptionGetTodaysSessions(
                message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessGetTodaysSessions(response: response));
        },
      );
    });
  }
}
