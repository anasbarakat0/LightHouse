import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/get_users_by_name_response_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_users_by_name_repo.dart';
import 'package:meta/meta.dart';

part 'get_users_by_name_event.dart';
part 'get_users_by_name_state.dart';

class GetUsersByNameBloc
    extends Bloc<GetUsersByNameEvent, GetUsersByNameState> {
  final GetUsersByNameRepo getUsersByNameRepo;

  GetUsersByNameBloc(this.getUsersByNameRepo) : super(GetUsersByNameInitial()) {
    on<GetUsersByName>((event, emit) async {
      emit(LoadingGettingUsersByName());
      var data = await getUsersByNameRepo.getUsersByNameRepo(event.name);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGettingUsersByName(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGettingUsersByName(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGettingUsersByName(message: failure.message));
            break;
          case NoDataFailure():
            emit(NoUsersFound(message: failure.message));
            break;
          default:
            emit(
                ExceptionGettingUsersByName(message: "Unknown error occurred"));
        }
      }, (response) {
        emit(SuccessGettingUsersByName(response: response));
      });
    });

    on<ResetUsersByNameSearch>((event, emit) {
      emit(GetUsersByNameInitial());
    });
  }
}
