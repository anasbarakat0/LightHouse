import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/admin_management/data/models/all_admin_info_response.dart';
import 'package:lighthouse/features/admin_management/domain/usecase/all_admin_info_usecase.dart';
import 'package:meta/meta.dart';

part 'all_admin_info_event.dart';
part 'all_admin_info_state.dart';

class AllAdminInfoBloc extends Bloc<AllAdminInfoEvent, AllAdminInfoState> {
  final AllAdminInfoUsecase allAdminInfoUsecase;
  AllAdminInfoBloc(this.allAdminInfoUsecase) : super(AllAdminInfoInitial()) {
    on<GetAdmins>((event, emit) async {
      var data = await allAdminInfoUsecase.call(event.page, event.size);

      data.fold((failure) {

        switch (failure) {
          case ServerFailure():
            emit(ErrorFetchingAdmins(failure.message));
            break;
          case ForbiddenFailure():
            emit(ForbiddenFetching(message: failure.message));
            break;
          case OfflineFailure():
            emit(ErrorFetchingAdmins("Check your network connection"));
            break;
          default:
            emit(ErrorFetchingAdmins("Try again later"));
        }
      }, (admins) {

        emit(SucessFetchingAdmins(admins));
      });
    });
  }
}
