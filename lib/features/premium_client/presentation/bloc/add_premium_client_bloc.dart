import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/new_premium_client_response.dart';
import 'package:lighthouse/features/premium_client/data/models/premium_client_model.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/add_premium_client_usecase.dart';
import 'package:meta/meta.dart';

part 'add_premium_client_event.dart';
part 'add_premium_client_state.dart';

class AddPremiumClientBloc
    extends Bloc<AddPremiumClientEvent, AddPremiumClientState> {
  final AddPremiumClientUsecase addPremiumClientUsecase;
  AddPremiumClientBloc(this.addPremiumClientUsecase)
      : super(AddPremiumClientInitial()) {
    on<AddPremiumClient>((event, emit) async {
      emit(LoadingAddingPremiumClient());
      var data = await addPremiumClientUsecase.call(event.client);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionAddedClient(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionAddedClient(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenAdded(message: failure.message));
            break;
          default:
        }
      }, (response) {
        emit(ClientAdded(response: response));
      });
    });
  }
}
