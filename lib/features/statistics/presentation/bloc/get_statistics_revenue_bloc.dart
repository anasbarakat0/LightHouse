import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_revenue_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_revenue_usecase.dart';
import 'package:meta/meta.dart';

part 'get_statistics_revenue_event.dart';
part 'get_statistics_revenue_state.dart';

class GetStatisticsRevenueBloc
    extends Bloc<GetStatisticsRevenueEvent, GetStatisticsRevenueState> {
  final GetStatisticsRevenueUsecase getStatisticsRevenueUsecase;

  GetStatisticsRevenueBloc({required this.getStatisticsRevenueUsecase})
      : super(GetStatisticsRevenueInitial()) {
    on<GetStatisticsRevenue>((event, emit) async {
      emit(LoadingGetStatisticsRevenue());
      var data = await getStatisticsRevenueUsecase.call(
        from: event.from,
        to: event.to,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetStatisticsRevenue(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetStatisticsRevenue(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetStatisticsRevenue(message: failure.message));
            break;
          default:
            emit(ExceptionGetStatisticsRevenue(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetStatisticsRevenue(response: response));
      });
    });
  }
}

