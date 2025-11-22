import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/coupons/data/models/get_all_coupons_response_model.dart';
import 'package:lighthouse/features/coupons/domain/usecase/get_all_coupons_usecase.dart';
import 'package:meta/meta.dart';

part 'get_all_coupons_event.dart';
part 'get_all_coupons_state.dart';

class GetAllCouponsBloc extends Bloc<GetAllCouponsEvent, GetAllCouponsState> {
  final GetAllCouponsUsecase getAllCouponsUsecase;

  GetAllCouponsBloc(this.getAllCouponsUsecase) : super(GetAllCouponsInitial()) {
    on<GetAllCoupons>((event, emit) async {
      emit(LoadingGetAllCoupons());
      final result = await getAllCouponsUsecase.call(
        page: event.page,
        size: event.size,
        active: event.active,
        discountType: event.discountType,
        appliesTo: event.appliesTo,
        codeSubstring: event.codeSubstring,
        sort: event.sort,
      );
      result.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(OfflineFailureGetAllCoupons(message: connectionMessage));
          } else if (failure is ForbiddenFailure) {
            emit(ExceptionGetAllCoupons(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(ExceptionGetAllCoupons(message: failure.message));
          } else if (failure is NoDataFailure) {
            emit(NoCouponsToShow(message: failure.message));
          } else {
            emit(ExceptionGetAllCoupons(
                message: "An unknown error occurred"));
          }
        },
        (response) {
          emit(SuccessGetAllCoupons(response: response));
        },
      );
    });
  }
}

