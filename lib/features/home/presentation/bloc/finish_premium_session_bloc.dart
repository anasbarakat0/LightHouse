import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/finish_premium_session_response_model.dart';
import 'package:lighthouse/features/home/domain/usecase/finish_premium_session_usecase.dart';
import 'package:meta/meta.dart';

part 'finish_premium_session_event.dart';
part 'finish_premium_session_state.dart';

class FinishPremiumSessionBloc
    extends Bloc<FinishPremiumSessionEvent, FinishPremiumSessionState> {
  final FinishPremiumSessionUsecase finishPremiumSessionUsecase;
  FinishPremiumSessionBloc(
    this.finishPremiumSessionUsecase,
  ) : super(FinishPremiumSessionInitial()) {
    on<FinishPreSession>((event, emit) async {

      var data = await finishPremiumSessionUsecase.call(event.id);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
           
            emit(ExceptionFinishPremiumSession(message: failure.message));
            break;
          case OfflineFailure():
          
            emit(ExceptionFinishPremiumSession(message: connectionMessage));
            break;
          case ForbiddenFailure():
           
            emit(ForbiddenFinishPremiumSession(message: failure.message));
            break;
          default:
           
            emit(LoadingFinishPremiumSession());
        }
      }, (response) {
        
        emit(SuccessFinishPremiumSession(response: response));
      });
    });
  }
}
