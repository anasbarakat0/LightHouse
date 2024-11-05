import 'package:bloc/bloc.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/setting/domain/usecase/get_hourly_price_usecase.dart';
import 'package:meta/meta.dart';

part 'get_hourly_price_event.dart';
part 'get_hourly_price_state.dart';

class GetHourlyPriceBloc
    extends Bloc<GetHourlyPriceEvent, GetHourlyPriceState> {
  final GetHourlyPriceUsecase getHourlyPriceUsecase;
  GetHourlyPriceBloc(this.getHourlyPriceUsecase)
      : super(GetHourlyPriceInitial()) {
    on<GetHourlyPrice>((event, emit) async {
      emit(LoadingGettingPrice());
      var data = await getHourlyPriceUsecase.call();
      print(987513);
      print(data.runtimeType);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ErrorGettingPrice(message: failure.message));
            break;

          case OfflineFailure():
            emit(OfflineGettingPrice(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(Forbidden());
            break;

          default:
            emit(LoadingGettingPrice());
        }
      }, (response) {
        emit(SuccessGettingPrice(price: response.body.hourlyPrice));
      });
    });
  }
}
