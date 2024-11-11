import 'package:bloc/bloc.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/packages/data/models/edit_package_model.dart';
import 'package:lighthouse_/features/packages/data/models/edit_packate_info_response_model.dart';
import 'package:lighthouse_/features/packages/domain/usecase/add_new_package_usecase.dart';
import 'package:meta/meta.dart';

part 'add_new_package_event.dart';
part 'add_new_package_state.dart';

class AddNewPackageBloc extends Bloc<AddNewPackageEvent, AddNewPackageState> {
  final AddNewPackageUsecase addNewPackageUsecase;
  AddNewPackageBloc(this.addNewPackageUsecase) : super(AddNewPackageInitial()) {
    on<AddPackage>((event, emit) async {
      var data = await addNewPackageUsecase.call(event.package);
      data.fold((failures) {
        switch (failures) {
          case ServerFailure():
            emit(ExceptionAddPackage(message: failures.message));
            break;
          case OfflineFailure():
            emit(ExceptionAddPackage(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenAddPackage(message: failures.message));
            break;
          default:

        }
      }, (response) {
        emit(PackageAdded(editPackageInfoResponseModel: response));
      });
    });
  }
}
