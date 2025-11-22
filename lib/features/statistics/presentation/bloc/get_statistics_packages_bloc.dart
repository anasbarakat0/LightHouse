import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_packages_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_packages_usecase.dart';
import 'package:meta/meta.dart';

part 'get_statistics_packages_event.dart';
part 'get_statistics_packages_state.dart';

class GetStatisticsPackagesBloc
    extends Bloc<GetStatisticsPackagesEvent, GetStatisticsPackagesState> {
  final GetStatisticsPackagesUsecase getStatisticsPackagesUsecase;

  GetStatisticsPackagesBloc({required this.getStatisticsPackagesUsecase})
      : super(GetStatisticsPackagesInitial()) {
    on<GetStatisticsPackages>((event, emit) async {
      emit(LoadingGetStatisticsPackages());
      var data = await getStatisticsPackagesUsecase.call(
        from: event.from,
        to: event.to,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetStatisticsPackages(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetStatisticsPackages(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetStatisticsPackages(message: failure.message));
            break;
          default:
            emit(ExceptionGetStatisticsPackages(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetStatisticsPackages(response: response));
      });
    });
  }
}

