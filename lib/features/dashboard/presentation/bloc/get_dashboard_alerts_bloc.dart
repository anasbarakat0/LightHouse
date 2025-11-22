import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_alerts_response_model.dart';
import 'package:lighthouse/features/dashboard/domain/usecase/get_dashboard_alerts_usecase.dart';

part 'get_dashboard_alerts_event.dart';
part 'get_dashboard_alerts_state.dart';

class GetDashboardAlertsBloc
    extends Bloc<GetDashboardAlertsEvent, GetDashboardAlertsState> {
  final GetDashboardAlertsUsecase getDashboardAlertsUsecase;

  GetDashboardAlertsBloc({required this.getDashboardAlertsUsecase})
      : super(GetDashboardAlertsInitial()) {
    on<GetDashboardAlerts>((event, emit) async {
      emit(LoadingGetDashboardAlerts());
      var data = await getDashboardAlertsUsecase.call();
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetDashboardAlerts(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetDashboardAlerts(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetDashboardAlerts(message: failure.message));
            break;
          default:
            emit(ExceptionGetDashboardAlerts(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetDashboardAlerts(response: response));
      });
    });
  }
}

