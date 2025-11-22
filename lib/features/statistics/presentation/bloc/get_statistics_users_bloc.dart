import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_users_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_users_usecase.dart';
import 'package:meta/meta.dart';

part 'get_statistics_users_event.dart';
part 'get_statistics_users_state.dart';

class GetStatisticsUsersBloc
    extends Bloc<GetStatisticsUsersEvent, GetStatisticsUsersState> {
  final GetStatisticsUsersUsecase getStatisticsUsersUsecase;

  GetStatisticsUsersBloc({required this.getStatisticsUsersUsecase})
      : super(GetStatisticsUsersInitial()) {
    on<GetStatisticsUsers>((event, emit) async {
      emit(LoadingGetStatisticsUsers());
      var data = await getStatisticsUsersUsecase.call(
        from: event.from,
        to: event.to,
        top: event.top,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetStatisticsUsers(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetStatisticsUsers(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetStatisticsUsers(message: failure.message));
            break;
          default:
            emit(ExceptionGetStatisticsUsers(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetStatisticsUsers(response: response));
      });
    });
  }
}

