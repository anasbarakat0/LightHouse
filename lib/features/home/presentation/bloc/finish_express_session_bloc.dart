import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/finish_express_session_response_model.dart';
import 'package:meta/meta.dart';

import 'package:lighthouse/features/home/domain/usecase/finish_express_session_usecase.dart';

part 'finish_express_session_event.dart';
part 'finish_express_session_state.dart';

class FinishExpressSessionBloc
    extends Bloc<FinishExpressSessionEvent, FinishExpressSessionState> {
  final FinishExpressSessionUsecase finishExpressSessionUsecase;
  FinishExpressSessionBloc(
    this.finishExpressSessionUsecase,
  ) : super(FinishExpressSessionInitial()) {
    on<FinishExpSession>((event, emit) async {
     
      var data = await finishExpressSessionUsecase.call(
        event.id,
        discountCode: event.discountCode,
        manualDiscountAmount: event.manualDiscountAmount,
        manualDiscountNote: event.manualDiscountNote,
      );
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
         
            emit(ExceptionFinishExpressSession(message: failure.message));
            break;
          case OfflineFailure():
       
            emit(ExceptionFinishExpressSession(message: connectionMessage));
            break;
          case ForbiddenFailure():
       
            emit(ForbiddenFinishExpressSession(message: failure.message));
            break;
          default:
     
            emit(LoadingFinishExpressSession());
        }
      }, (response) {
    
        emit(SuccessFinishExpressSession(response: response));
      });
    });
  }
}
