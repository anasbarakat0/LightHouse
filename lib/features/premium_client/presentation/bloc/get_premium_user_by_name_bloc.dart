import 'package:bloc/bloc.dart';
import 'package:lighthouse/features/premium_client/data/models/get_premium_user_by_name_response.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_premium_user_by_name_repo.dart';
import 'package:meta/meta.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';

part 'get_premium_user_by_name_event.dart';
part 'get_premium_user_by_name_state.dart';

class GetPremiumUserByNameBloc
    extends Bloc<GetPremiumUserByNameEvent, GetPremiumUserByNameState> {
  final GetPremiumUserByNameRepo getPremiumUserByNameRepo;
  GetPremiumUserByNameBloc(this.getPremiumUserByNameRepo)
      : super(GetPremiumUserByNameInitial()) {
    on<GetPremiumUserByName>((event, emit) async {
      var data = await getPremiumUserByNameRepo.getPremiumUserByNameRepo(event.name);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGettingPremiumUserByName(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGettingPremiumUserByName(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGettingPremiumUserByName(message: failure.message));
            break;
          default:
        }
      }, (response) {
        emit(SuccessGettingPremiumUserByName(response: response));
      });
    });
  }
}
