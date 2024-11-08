import 'package:bloc/bloc.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse_/features/premium_client/domain/usecase/get_premium_clients_usecase.dart';
import 'package:meta/meta.dart';

part 'get_premium_clients_event.dart';
part 'get_premium_clients_state.dart';

class GetPremiumClientsBloc
    extends Bloc<GetPremiumClientsEvent, GetPremiumClientsState> {
  final GetPremiumClientsUsecase getPremiumClientsUsecase;
  GetPremiumClientsBloc(this.getPremiumClientsUsecase)
      : super(GetPremiumClientsInitial()) {
    on<GetPremiumClients>((event, emit) async {
      emit(LoadingFetchingClients());
      var data = await getPremiumClientsUsecase.call(event.page, event.size);
      data.fold((failures) {

        switch (failures) {
          case OfflineFailure():
          print("45177");
            emit(OfflineFailureState(message: connectionMessage));
            break;
          case ServerFailure():
          print("45141");
            emit(ExceptionFetchingClients(message: failures.message));
            break;
          case ForbiddenFailure():
          print("45118");
            emit(ExceptionFetchingClients(message: failures.message));
            break;
          case NoDataFailure():
          print("45128");
            emit(NoClientsToShow(message: failures.message));
            break;
          default:
          print("45137");
            emit(LoadingFetchingClients());
        }
      }, (response) {
          print("45176");
        emit(SuccessFetchingClients(responseModel: response));
      });
    });
  }
}
