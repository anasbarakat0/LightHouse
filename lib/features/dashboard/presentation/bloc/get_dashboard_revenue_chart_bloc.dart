import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/dashboard_revenue_chart_response_model.dart';
import 'package:lighthouse/features/dashboard/domain/usecase/get_dashboard_revenue_chart_usecase.dart';

part 'get_dashboard_revenue_chart_event.dart';
part 'get_dashboard_revenue_chart_state.dart';

class GetDashboardRevenueChartBloc
    extends Bloc<GetDashboardRevenueChartEvent, GetDashboardRevenueChartState> {
  final GetDashboardRevenueChartUsecase getDashboardRevenueChartUsecase;

  GetDashboardRevenueChartBloc({required this.getDashboardRevenueChartUsecase})
      : super(GetDashboardRevenueChartInitial()) {
    on<GetDashboardRevenueChart>((event, emit) async {
      emit(LoadingGetDashboardRevenueChart());
      var data = await getDashboardRevenueChartUsecase.call(
        period: event.period,
        from: event.from,
        to: event.to,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetDashboardRevenueChart(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetDashboardRevenueChart(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetDashboardRevenueChart(message: failure.message));
            break;
          default:
            emit(ExceptionGetDashboardRevenueChart(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetDashboardRevenueChart(response: response));
      });
    });
  }
}

