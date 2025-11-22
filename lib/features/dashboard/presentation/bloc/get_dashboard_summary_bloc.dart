import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_summary_response_model.dart';
import 'package:lighthouse/features/dashboard/domain/usecase/get_dashboard_summary_usecase.dart';

part 'get_dashboard_summary_event.dart';
part 'get_dashboard_summary_state.dart';

class GetDashboardSummaryBloc
    extends Bloc<GetDashboardSummaryEvent, GetDashboardSummaryState> {
  final GetDashboardSummaryUsecase getDashboardSummaryUsecase;

  GetDashboardSummaryBloc({required this.getDashboardSummaryUsecase})
      : super(GetDashboardSummaryInitial()) {
    on<GetDashboardSummary>((event, emit) async {
      emit(LoadingGetDashboardSummary());
      var data = await getDashboardSummaryUsecase.call();
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetDashboardSummary(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetDashboardSummary(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetDashboardSummary(message: failure.message));
            break;
          default:
            emit(ExceptionGetDashboardSummary(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetDashboardSummary(response: response));
      });
    });
  }
}

