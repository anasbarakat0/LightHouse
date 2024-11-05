import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/premium_client/data/models/admin_by_id_response_model.dart';
import 'package:lighthouse_/features/premium_client/domain/usecase/admin_by_id_usecase.dart';
import 'package:meta/meta.dart';

part 'admin_by_id_event.dart';
part 'admin_by_id_state.dart';

class AdminByIdBloc extends Bloc<AdminByIdEvent, AdminByIdState> {
  final AdminByIdUsecase adminByIdUsecase;
  AdminByIdBloc(this.adminByIdUsecase) : super(AdminByIdInitial()) {
    on<GetAdminById>((event, emit) async {
      emit(LoadingGettingAdmin());
      print(3);
      var data = await adminByIdUsecase.call(event.id);
      print(9);
      data.fold((failure) {
        switch (failure) {
          case OfflineFailure():
            emit(OfflineGetting(message: connectionMessage));
            break;
          case ServerFailure():
            emit(ExceptionGettingAdmin(message: failure.message));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGetting(message: failure.message));
            break;
          default:
            emit(LoadingGettingAdmin());
        }
      }, (response) {
        emit(SuccessGettingAdmin(response: response));
      });
    });
  }
}
