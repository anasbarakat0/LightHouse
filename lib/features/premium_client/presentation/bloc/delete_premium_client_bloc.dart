import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/delete_premium_client_usecase.dart';
import 'package:meta/meta.dart';

part 'delete_premium_client_event.dart';
part 'delete_premium_client_state.dart';

class DeletePremiumClientBloc
    extends Bloc<DeletePremiumClientEvent, DeletePremiumClientState> {
  final DeletePremiumClientUsecase deletePremiumClientUsecase;

  DeletePremiumClientBloc(this.deletePremiumClientUsecase)
      : super(DeletePremiumClientInitial()) {
    on<DeletePremiumClient>((event, emit) async {
      emit(LoadingDeletePremiumClient());
      final result = await deletePremiumClientUsecase.call(event.userId);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureDeletePremiumClient(
                message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionDeletePremiumClient(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionDeletePremiumClient(message: failure.message));
          } else {
            emit(ExceptionDeletePremiumClient(
                message: "An unknown error occurred"));
          }
        },
        (message) {
          emit(SuccessDeletePremiumClient(message: message));
        },
      );
    });
  }
}

