import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_overview_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_overview_usecase.dart';
import 'package:meta/meta.dart';

part 'get_statistics_overview_event.dart';
part 'get_statistics_overview_state.dart';

class GetStatisticsOverviewBloc
    extends Bloc<GetStatisticsOverviewEvent, GetStatisticsOverviewState> {
  final GetStatisticsOverviewUsecase getStatisticsOverviewUsecase;

  GetStatisticsOverviewBloc({required this.getStatisticsOverviewUsecase})
      : super(GetStatisticsOverviewInitial()) {
    on<GetStatisticsOverview>((event, emit) async {
      emit(LoadingGetStatisticsOverview());
      var data = await getStatisticsOverviewUsecase.call(
        from: event.from,
        to: event.to,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetStatisticsOverview(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetStatisticsOverview(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetStatisticsOverview(message: failure.message));
            break;
          default:
            emit(ExceptionGetStatisticsOverview(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetStatisticsOverview(response: response));
      });
    });
  }
}

