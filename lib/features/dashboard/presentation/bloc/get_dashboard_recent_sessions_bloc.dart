import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_recent_sessions_response_model.dart';
import 'package:lighthouse/features/dashboard/domain/usecase/get_dashboard_recent_sessions_usecase.dart';

part 'get_dashboard_recent_sessions_event.dart';
part 'get_dashboard_recent_sessions_state.dart';

class GetDashboardRecentSessionsBloc
    extends Bloc<GetDashboardRecentSessionsEvent, GetDashboardRecentSessionsState> {
  final GetDashboardRecentSessionsUsecase getDashboardRecentSessionsUsecase;

  GetDashboardRecentSessionsBloc({required this.getDashboardRecentSessionsUsecase})
      : super(GetDashboardRecentSessionsInitial()) {
    on<GetDashboardRecentSessions>((event, emit) async {
      emit(LoadingGetDashboardRecentSessions());
      var data = await getDashboardRecentSessionsUsecase.call(limit: event.limit);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetDashboardRecentSessions(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetDashboardRecentSessions(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetDashboardRecentSessions(message: failure.message));
            break;
          default:
            emit(ExceptionGetDashboardRecentSessions(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetDashboardRecentSessions(response: response));
      });
    });
  }
}

