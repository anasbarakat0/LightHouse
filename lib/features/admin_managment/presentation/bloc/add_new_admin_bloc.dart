import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/admin_managment/data/models/new_admin_model.dart';
import 'package:lighthouse_/features/admin_managment/data/models/new_admin_response_model.dart';
import 'package:lighthouse_/features/admin_managment/domain/usecase/add_new_admin_usecase.dart';
import 'package:meta/meta.dart';

part 'add_new_admin_event.dart';
part 'add_new_admin_state.dart';

class AddNewAdminBloc extends Bloc<AddNewAdminEvent, AddNewAdminState> {
  final AddNewAdminUsecase addNewAdminUsecase;
  AddNewAdminBloc(this.addNewAdminUsecase) : super(AddNewAdminInitial()) {
    on<AddAdmin>((event, emit) async {
      print("usecase new admin");
      var data = await addNewAdminUsecase.call(event.admin);
      print("usecase new admin data done before folding");

      data.fold((failure) {
        switch (failure) {
          case OfflineFailure():
            emit(ErrorCreatingAdmin(
                messages: const ["Check your internet connection"]));
            break;
          case ServerFailure():
            emit(ErrorCreatingAdmin(messages: [failure.message]));
            break;
          case AddNewAdminFailure():
            emit(ErrorCreatingAdmin(messages: failure.messages));
            break;
          default:
            emit(ErrorCreatingAdmin(messages: const ["Try again later"]));
        }
      }, (response) {
        emit(AdminCreated(response: response));
      });
    });
  }
}
