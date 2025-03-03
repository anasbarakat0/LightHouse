import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/get_express_session_response.dart';
import 'package:lighthouse/features/home/data/repository/get_express_session_by_id_repo.dart';
import 'package:meta/meta.dart';

part 'get_express_session_event.dart';
part 'get_express_session_state.dart';

class GetExpressSessionBloc extends Bloc<GetExpressSessionEvent, GetExpressSessionState> {
  final GetExpressSessionByIdRepo getExpressSessionByIdRepo;
  GetExpressSessionBloc(this.getExpressSessionByIdRepo) : super(GetExpressSessionInitial()){
    on<GetExpressSession>((event, emit) async {
      var data = await getExpressSessionByIdRepo.getExpressSessionByIdRepo(event.id);
      data.fold((failure) {
         switch (failure) {
          case ServerFailure():
            emit(ExceptionGettingExpressSession(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGettingExpressSession(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGettingExpressSession(message: failure.message));
            break;
          default:
        }
      }, (response) {
     
        emit(SuccessGettingExpressSession(response: response));
      });
    });
  }
}
