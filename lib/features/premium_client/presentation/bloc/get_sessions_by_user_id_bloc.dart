import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/get_sessions_by_user_id_response_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_sessions_by_user_id_repo.dart';
import 'package:meta/meta.dart';

part 'get_sessions_by_user_id_event.dart';
part 'get_sessions_by_user_id_state.dart';

class GetSessionsByUserIdBloc
    extends Bloc<GetSessionsByUserIdEvent, GetSessionsByUserIdState> {
  final GetSessionsByUserIdRepo repo;
  GetSessionsByUserIdBloc(this.repo) : super(GetSessionsByUserIdInitial()) {
    on<GetSessionsByUserId>((event, emit) async {
      emit(LoadingFetchingSessions());
      final result = await repo.getSessionsByUserIdRepo(
          event.userId, event.page, event.size);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureSessionsState(message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionFetchingSessions(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionFetchingSessions(message: failure.message));
          } else if (failure is NoDataFailure) {
            emit(NoSessions(message: failure.message));
          } else {
            emit(ExceptionFetchingSessions(
                message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessFetchingSessions(response: response));
        },
      );
    });
  }
}

