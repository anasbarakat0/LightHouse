import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/start_premium_session_usecase.dart';
import 'package:meta/meta.dart';

part 'start_premium_session_event.dart';
part 'start_premium_session_state.dart';

class StartPremiumSessionBloc
    extends Bloc<StartPremiumSessionEvent, StartPremiumSessionState> {
  final StartPremiumSessionUsecase startPremiumSessionUsecase;
  StartPremiumSessionBloc(this.startPremiumSessionUsecase)
      : super(StartPremiumSessionInitial()) {
    on<StartPreSession>((event, emit) async {
      var data = await startPremiumSessionUsecase.call(event.id);
      data.fold((failures) {
        switch (failures) {
          case OfflineFailure():
            print("45177");
            emit(ExceptionStartSession(message: connectionMessage));
            break;
          case ServerFailure():
            print("45141");
            emit(ExceptionStartSession(message: failures.message));
            break;
          case ForbiddenFailure():
            print("45118");
            emit(ForbiddenStartSession(message: failures.message));
            break;

          default:
            print("45137");
            emit(LoadingStartSession());
        }
      }, (response) {
        print("4517691");
        print("response: $response");
        emit(SuccessStartSession(response: response));
      });
    });
  }
}
