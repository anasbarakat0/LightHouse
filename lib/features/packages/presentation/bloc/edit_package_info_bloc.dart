import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:meta/meta.dart';

import 'package:lighthouse/features/packages/data/models/edit_package_model.dart';
import 'package:lighthouse/features/packages/data/models/edit_packate_info_response_model.dart';
import 'package:lighthouse/features/packages/domain/usecase/edit_package_info_usecase.dart';

part 'edit_package_info_event.dart';
part 'edit_package_info_state.dart';

class EditPackageInfoBloc
    extends Bloc<EditPackageInfoEvent, EditPackageInfoState> {
  final EditPackageInfoUsecase editPackageInfoUsecase;
  EditPackageInfoBloc(
    this.editPackageInfoUsecase,
  ) : super(EditPackageInfoInitial()) {
    on<EditPackageInfo>((event, emit) async {
      emit(LoadingEditPackage());
      var data = await editPackageInfoUsecase.call(event.id, event.package);
      data.fold((failures) {
        switch (failures) {
          case ServerFailure():
            emit(ExceptionEditPackage(message: failures.message));
            break;
          case OfflineFailure():
            emit(ExceptionEditPackage(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenEditPackage(message: failures.message));
            break;
          default:

        }
      }, (response) {
        emit(PackageEdited(editPackageInfoResponseModel: response));
      });
    });
  }
}
