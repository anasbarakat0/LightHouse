import 'package:bloc/bloc.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:meta/meta.dart';

import 'package:lighthouse_/features/home/data/models/active_sessions_response_model.dart';
import 'package:lighthouse_/features/home/domain/usecase/get_all_active_sessions_usecase.dart';

part 'get_all_active_sessions_event.dart';
part 'get_all_active_sessions_state.dart';

class GetAllActiveSessionsBloc extends Bloc<GetAllActiveSessionsEvent, GetAllActiveSessionsState> {
  final GetAllActiveSessionsUsecase getAllActiveSessionsUsecase;
  GetAllActiveSessionsBloc(
    this.getAllActiveSessionsUsecase,
  ) : super(GetAllActiveSessionsInitial()){
    on<GetActiveSessions>((event, emit) async {
      var data = await getAllActiveSessionsUsecase.call();
      data.fold((failure){
         switch (failure) {
          case ServerFailure():
            emit(ExceptionGettingSessions(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGettingSessions(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGettingSessions(message: failure.message));
            break;
          default:
        }
      }, (response){
        print("emit(SuccessGettingSessions(response: response));");
        emit(SuccessGettingSessions(response: response));
      });
    });
  }

}
