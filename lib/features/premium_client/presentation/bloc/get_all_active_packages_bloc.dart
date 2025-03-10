import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:meta/meta.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_active_packages_response.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_all_active_packages_repo.dart';

part 'get_all_active_packages_event.dart';
part 'get_all_active_packages_state.dart';

class GetAllActivePackagesBloc
    extends Bloc<GetAllActivePackagesEvent, GetAllActivePackagesState> {
  final GetAllActivePackagesRepo repo;
  GetAllActivePackagesBloc(this.repo) : super(GetAllActivePackagesInitial()) {
    on<GetAllActivePackages>((event, emit) async {
      emit(LoadingFetchingActivePackages());
      final result =
          await repo.getAllActivePackagesRepo(event.page, event.size);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureActivePackagesState(message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionFetchingActivePackages(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionFetchingActivePackages(message: failure.message));
          } else if (failure is NoDataFailure) {
            emit(NoActivePackages(message: failure.message));
          } else {
            emit(ExceptionFetchingActivePackages(
                message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessFetchingActivePackages(response: response));
        },
      );
    });
  }
}
