import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/coupons/data/models/delete_coupon_response_model.dart';
import 'package:lighthouse/features/coupons/domain/usecase/delete_coupon_usecase.dart';
import 'package:meta/meta.dart';

part 'delete_coupon_event.dart';
part 'delete_coupon_state.dart';

class DeleteCouponBloc extends Bloc<DeleteCouponEvent, DeleteCouponState> {
  final DeleteCouponUsecase deleteCouponUsecase;

  DeleteCouponBloc(this.deleteCouponUsecase) : super(DeleteCouponInitial()) {
    on<DeleteCoupon>((event, emit) async {
      emit(LoadingDeleteCoupon());
      final result = await deleteCouponUsecase.call(event.couponId);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureDeleteCoupon(message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionDeleteCoupon(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionDeleteCoupon(message: failure.message));
          } else if (failure is NoDataFailure) {
            emit(ExceptionDeleteCoupon(message: failure.message));
          } else {
            emit(ExceptionDeleteCoupon(
                message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessDeleteCoupon(response: response));
        },
      );
    });
  }
}

