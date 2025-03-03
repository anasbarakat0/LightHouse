import 'package:bloc/bloc.dart';
import 'package:lighthouse/common/model/success_response_model.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/admin_management/domain/usecase/delete_admin_usecase.dart';
import 'package:meta/meta.dart';

part 'delete_admin_event.dart';
part 'delete_admin_state.dart';

class DeleteAdminBloc extends Bloc<DeleteAdminEvent, DeleteAdminState> {
  final DeleteAdminUsecase deleteAdminUsecase;
  DeleteAdminBloc(this.deleteAdminUsecase) : super(DeleteAdminInitial()) {
    on<DeleteAdmin>((event, emit) async {
      emit(LoadingDeleting());
      var data = await deleteAdminUsecase.call(event.id);
      data.fold((failure) {
        switch (failure) {
          case ForbiddenFailure():
            emit(ForbiddenDeleteState(message: failure.message));
            break;
          case ServerFailure():
            emit(ExceptionDeleteAdmin(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionDeleteAdmin(message: connectionMessage));
            break;
          default:
            emit(ExceptionDeleteAdmin(message: "Try again later"));
        }
      }, (deleted) {
        emit(AdminDeleted(response: deleted));
      });
    });
  }
}
