import 'package:bloc/bloc.dart';
import 'package:lighthouse_/core/constants/messages.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/packages/data/models/all_active_packages_response_model.dart';
import 'package:lighthouse_/features/packages/domain/usecase/get_all_active_packages_usecase.dart';
import 'package:meta/meta.dart';

part 'get_all_active_packages_event.dart';
part 'get_all_active_packages_state.dart';

class GetAllActivePackagesBloc
    extends Bloc<GetAllActivePackagesEvent, GetAllActivePackagesState> {
  final GetAllActivePackagesUsecase getAllActivePackagesUsecase;
  GetAllActivePackagesBloc(this.getAllActivePackagesUsecase)
      : super(GetAllActivePackagesInitial()) {
    on<GetAllActivePackages>((event, emit) async {
      var data = await getAllActivePackagesUsecase.call(event.page, event.size);
      data.fold((failures) {
        switch (failures) {
          case ServerFailure():
            emit(ExceptionWhilePackages(message: failures.message));
            break;
          case OfflineFailure():
            emit(ExceptionWhilePackages(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenShowingPackage(message: failures.message));
            break;
          default:
        }
      }, (response) {
        switch (response) {
          case NoActivePackages():
            emit(NoPackagesToShow(noActivePackages: response));
            break;
          case ActivePackages():
            emit(ShowingAllPackages(activePackages: response));
            break;
          default:
        }
      });
    });
  }
}
