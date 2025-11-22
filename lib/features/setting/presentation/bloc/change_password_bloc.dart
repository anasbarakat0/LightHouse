import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/setting/data/models/change_password_model.dart';
import 'package:lighthouse/features/setting/domain/usecase/change_password_usecase.dart';
import 'package:meta/meta.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUsecase changePasswordUsecase;

  ChangePasswordBloc(this.changePasswordUsecase)
      : super(ChangePasswordInitial()) {
    on<ChangePassword>((event, emit) async {
      emit(LoadingChangePassword());
      final result = await changePasswordUsecase.call(event.changePasswordModel);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureChangePassword(message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionChangePassword(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionChangePassword(message: failure.message));
          } else {
            emit(ExceptionChangePassword(
                message: "An unknown error occurred"));
          }
        },
        (message) {
          emit(SuccessChangePassword(message: message));
        },
      );
    });
  }
}

