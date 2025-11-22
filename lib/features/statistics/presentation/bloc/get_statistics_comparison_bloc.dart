import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_comparison_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_comparison_usecase.dart';
import 'package:meta/meta.dart';

part 'get_statistics_comparison_event.dart';
part 'get_statistics_comparison_state.dart';

class GetStatisticsComparisonBloc
    extends Bloc<GetStatisticsComparisonEvent, GetStatisticsComparisonState> {
  final GetStatisticsComparisonUsecase getStatisticsComparisonUsecase;

  GetStatisticsComparisonBloc({required this.getStatisticsComparisonUsecase})
      : super(GetStatisticsComparisonInitial()) {
    on<GetStatisticsComparison>((event, emit) async {
      emit(LoadingGetStatisticsComparison());
      var data = await getStatisticsComparisonUsecase.call(
        currentFrom: event.currentFrom,
        currentTo: event.currentTo,
        previousFrom: event.previousFrom,
        previousTo: event.previousTo,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetStatisticsComparison(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetStatisticsComparison(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetStatisticsComparison(message: failure.message));
            break;
          default:
            emit(ExceptionGetStatisticsComparison(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetStatisticsComparison(response: response));
      });
    });
  }
}

