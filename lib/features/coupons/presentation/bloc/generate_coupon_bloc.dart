import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/coupons/data/models/generate_coupon_request_model.dart';
import 'package:lighthouse/features/coupons/data/models/generate_coupon_response_model.dart';
import 'package:lighthouse/features/coupons/domain/usecase/generate_coupon_usecase.dart';
import 'package:meta/meta.dart';

part 'generate_coupon_event.dart';
part 'generate_coupon_state.dart';

class GenerateCouponBloc
    extends Bloc<GenerateCouponEvent, GenerateCouponState> {
  final GenerateCouponUsecase generateCouponUsecase;

  GenerateCouponBloc(this.generateCouponUsecase)
      : super(GenerateCouponInitial()) {
    on<GenerateCoupon>((event, emit) async {
      emit(LoadingGenerateCoupon());
      final result = await generateCouponUsecase.call(event.request);
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureGenerateCoupon(message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionGenerateCoupon(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionGenerateCoupon(message: failure.message));
          } else if (failure is NoDataFailure) {
            emit(ExceptionGenerateCoupon(message: failure.message));
          } else {
            emit(ExceptionGenerateCoupon(
                message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessGenerateCoupon(response: response));
        },
      );
    });
  }
}

