// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:meta/meta.dart';

import 'package:lighthouse_/features/mian_window/data/models/express_session_response_model.dart';
import 'package:lighthouse_/features/mian_window/domain/usecase/start_express_session_usecase.dart';

part 'start_express_session_event.dart';
part 'start_express_session_state.dart';

class StartExpressSessionBloc
    extends Bloc<StartExpressSessionEvent, StartExpressSessionState> {
  final StartExpressSessionUsecase usecase;
  StartExpressSessionBloc(
    this.usecase,
  ) : super(StartExpressSessionInitial()) {
    on<StartExpressSession>((event, emit) async {
      emit(LoadingSessionStarted());
      var data = await usecase.call(event.fullName);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionSessionStarted(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionSessionStarted(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenSessionStarted(message: failure.message));
            break;
          default:
        }
      }, (response) {
        print("object22312323123123123123123123123123123");
        emit(SessionStarted(response: response));
      });
    });
  }
}
