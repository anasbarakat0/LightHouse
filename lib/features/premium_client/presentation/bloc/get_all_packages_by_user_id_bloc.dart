import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_packages_by_user_id_response.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_all_packages_by_user_id_repo.dart';
import 'package:meta/meta.dart';

part 'get_all_packages_by_user_id_event.dart';
part 'get_all_packages_by_user_id_state.dart';

class GetAllPackagesByUserIdBloc
    extends Bloc<GetAllPackagesByUserIdEvent, GetAllPackagesByUserIdState> {
  final GetAllPackagesByUserIdRepo repo;
  GetAllPackagesByUserIdBloc(this.repo)
      : super(GetAllPackagesByUserIdInitial()) {
    on<GetAllPackagesByUserId>((event, emit) async {
      emit(LoadingFetchingPackages());
      final result = await repo.getAllPackagesByUserIdRepo(
          event.userId, event.page, event.size);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureState(message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionFetchingPackages(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionFetchingPackages(message: failure.message));
          } else if (failure is NoDataFailure) {
            emit(NoPackages(message: failure.message));
          } else {
            emit(ExceptionFetchingPackages(
                message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessFetchingPackages(response: response));
        },
      );
    });
  }
}
