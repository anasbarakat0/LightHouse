import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/new_premium_client_response.dart';
import 'package:lighthouse/features/premium_client/data/models/update_premium_client_model.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/update_premium_client_usecase.dart';
import 'package:meta/meta.dart';

part 'update_premium_client_event.dart';
part 'update_premium_client_state.dart';

class UpdatePremiumClientBloc
    extends Bloc<UpdatePremiumClientEvent, UpdatePremiumClientState> {
  final UpdatePremiumClientUsecase updatePremiumClientUsecase;

  UpdatePremiumClientBloc(this.updatePremiumClientUsecase)
      : super(UpdatePremiumClientInitial()) {
    on<UpdatePremiumClient>((event, emit) async {
      emit(LoadingUpdatePremiumClient());
      final result = await updatePremiumClientUsecase.call(
          event.userId, event.client);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureUpdatePremiumClient(
                message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionUpdatePremiumClient(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionUpdatePremiumClient(message: failure.message));
          } else {
            emit(ExceptionUpdatePremiumClient(
                message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessUpdatePremiumClient(response: response));
        },
      );
    });
  }
}

