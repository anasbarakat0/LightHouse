import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/subscribe_user_to_package_response.dart';
import 'package:lighthouse/features/premium_client/data/repository/subscribe_user_to_package_repo.dart';

part 'subscribe_user_to_package_event.dart';
part 'subscribe_user_to_package_state.dart';

class SubscribeUserToPackageBloc extends Bloc<SubscribeUserToPackageEvent, SubscribeUserToPackageState> {
  final SubscribeUserToPackageRepo repo;
  SubscribeUserToPackageBloc(this.repo) : super(SubscribeUserToPackageInitial()) {
    on<SubscribeUserToPackage>((event, emit) async {
      emit(LoadingSubscribeUserToPackage());
      final result = await repo.subscribeUserToPackageRepo(event.packageId, event.userId);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureSubscribeUserToPackage(message: "No internet connection"));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionSubscribeUserToPackage(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionSubscribeUserToPackage(message: failure.message));
          } else {
            emit(ExceptionSubscribeUserToPackage(message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessSubscribeUserToPackage(response: response));
        },
      );
    });
  }
}
