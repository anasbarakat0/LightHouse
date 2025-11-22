import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/coupons/data/models/deactivate_coupon_response_model.dart';
import 'package:lighthouse/features/coupons/domain/usecase/deactivate_coupon_usecase.dart';
import 'package:meta/meta.dart';

part 'deactivate_coupon_event.dart';
part 'deactivate_coupon_state.dart';

class DeactivateCouponBloc
    extends Bloc<DeactivateCouponEvent, DeactivateCouponState> {
  final DeactivateCouponUsecase deactivateCouponUsecase;

  DeactivateCouponBloc(this.deactivateCouponUsecase)
      : super(DeactivateCouponInitial()) {
    on<DeactivateCoupon>((event, emit) async {
      emit(LoadingDeactivateCoupon());
      final result = await deactivateCouponUsecase.call(event.couponId);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureDeactivateCoupon(message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionDeactivateCoupon(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionDeactivateCoupon(message: failure.message));
          } else if (failure is NoDataFailure) {
            emit(ExceptionDeactivateCoupon(message: failure.message));
          } else {
            emit(ExceptionDeactivateCoupon(
                message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessDeactivateCoupon(response: response));
        },
      );
    });
  }
}

