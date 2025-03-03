import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/setting/domain/usecase/edit_hourly_price_usecase.dart';
import 'package:meta/meta.dart';

part 'edit_hourly_price_event.dart';
part 'edit_hourly_price_state.dart';

class EditHourlyPriceBloc extends Bloc<EditHourlyPriceEvent, EditHourlyPriceState> {
  final EditHourlyPriceUsecase editHourlyPriceUsecase;
  EditHourlyPriceBloc(this.editHourlyPriceUsecase) : super(EditHourlyPriceInitial()){
    on<EditHourlyPrice>((event, emit) async {
      emit(LoadingEditingPrice());
      var data = await editHourlyPriceUsecase.call(event.hourlyPrice);
      data.fold((failure){
         switch (failure) {
          case ServerFailure():
            emit(ErrorEditingPrice(message: failure.message));
            break;

          case OfflineFailure():
            emit(OfflineEditingPrice(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenEditing());
            break;

          default:
            emit(LoadingEditingPrice());
        }
      }, (response){
        emit(SuccessEditingPrice(price: response.body.hourlyPrice,message: response.message));
      });
    });
  }
}
