import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/buffet_order_request_model.dart';
import 'package:lighthouse/features/home/domain/usecase/premium_buffet_usecase.dart';
import 'package:meta/meta.dart';

part 'premium_buffet_event.dart';
part 'premium_buffet_state.dart';

class PremiumBuffetBloc extends Bloc<PremiumBuffetEvent, PremiumBuffetState> {
  final PremiumBuffetUsecase premiumBuffetUsecase;

  PremiumBuffetBloc(this.premiumBuffetUsecase) : super(PremiumBuffetInitial()) {
    on<AddBuffetOrdersToPremiumSession>((event, emit) async {
      emit(PremiumBuffetLoading());
      final data = await premiumBuffetUsecase.addOrdersToPremiumSession(
        event.sessionId,
        event.orders,
      );
      data.fold(
        (failure) => _emitFailure(failure, emit),
        (response) => emit(PremiumBuffetActionSuccess(
          response: response,
          sessionId: event.sessionId,
        )),
      );
    });

    on<CreateBuffetInvoiceByQrCode>((event, emit) async {
      emit(PremiumBuffetLoading());
      final data = await premiumBuffetUsecase.createBuffetInvoiceByQrCode(
        event.qrCode,
        event.orders,
      );
      data.fold(
        (failure) => _emitFailure(failure, emit),
        (response) => emit(PremiumBuffetActionSuccess(response: response)),
      );
    });

    on<GetPremiumBuffetInvoices>((event, emit) async {
      emit(PremiumBuffetLoading());
      final data =
          await premiumBuffetUsecase.getPremiumBuffetInvoices(event.sessionId);
      data.fold(
        (failure) => _emitFailure(failure, emit),
        (response) => emit(PremiumBuffetInvoicesLoaded(
          response: response,
          sessionId: event.sessionId,
        )),
      );
    });

    on<UpdateBuffetOrderQuantity>((event, emit) async {
      emit(PremiumBuffetLoading());
      final data = await premiumBuffetUsecase.updateBuffetOrder(
        event.orderId,
        event.quantity,
      );
      data.fold(
        (failure) => _emitFailure(failure, emit),
        (response) => emit(PremiumBuffetActionSuccess(
          response: response,
          sessionId: event.sessionId,
        )),
      );
    });

    on<DeleteBuffetOrder>((event, emit) async {
      emit(PremiumBuffetLoading());
      final data = await premiumBuffetUsecase.deleteBuffetOrder(event.orderId);
      data.fold(
        (failure) => _emitFailure(failure, emit),
        (response) => emit(PremiumBuffetActionSuccess(
          response: response,
          sessionId: event.sessionId,
        )),
      );
    });
  }

  void _emitFailure(
    Failures failure,
    Emitter<PremiumBuffetState> emit,
  ) {
    switch (failure) {
      case ServerFailure():
        emit(PremiumBuffetException(message: failure.message));
        break;
      case OfflineFailure():
        emit(PremiumBuffetException(message: connectionMessage));
        break;
      case ForbiddenFailure():
        emit(PremiumBuffetForbidden(message: failure.message));
        break;
      default:
        emit(PremiumBuffetException(message: connectionMessage));
    }
  }
}
