import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/statistics/data/models/statistics_coupons_response_model.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_statistics_coupons_usecase.dart';
import 'package:meta/meta.dart';

part 'get_statistics_coupons_event.dart';
part 'get_statistics_coupons_state.dart';

class GetStatisticsCouponsBloc
    extends Bloc<GetStatisticsCouponsEvent, GetStatisticsCouponsState> {
  final GetStatisticsCouponsUsecase getStatisticsCouponsUsecase;

  GetStatisticsCouponsBloc({required this.getStatisticsCouponsUsecase})
      : super(GetStatisticsCouponsInitial()) {
    on<GetStatisticsCoupons>((event, emit) async {
      emit(LoadingGetStatisticsCoupons());
      var data = await getStatisticsCouponsUsecase.call(
        from: event.from,
        to: event.to,
        top: event.top,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGetStatisticsCoupons(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGetStatisticsCoupons(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetStatisticsCoupons(message: failure.message));
            break;
          default:
            emit(ExceptionGetStatisticsCoupons(message: "Unknown error"));
        }
      }, (response) {
        emit(SuccessGetStatisticsCoupons(response: response));
      });
    });
  }
}

