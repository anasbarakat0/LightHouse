import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/close_premium_session_by_qr_code_response_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/close_premium_session_by_qr_code_repo.dart';
import 'package:meta/meta.dart';

part 'close_premium_session_by_qr_code_event.dart';
part 'close_premium_session_by_qr_code_state.dart';

class ClosePremiumSessionByQrCodeBloc extends Bloc<
    ClosePremiumSessionByQrCodeEvent, ClosePremiumSessionByQrCodeState> {
  final ClosePremiumSessionByQrCodeRepo closePremiumSessionByQrCodeRepo;

  ClosePremiumSessionByQrCodeBloc(this.closePremiumSessionByQrCodeRepo)
      : super(ClosePremiumSessionByQrCodeInitial()) {
    on<ClosePremiumSessionByQrCode>((event, emit) async {
      emit(LoadingClosingPremiumSessionByQrCode());
      var data = await closePremiumSessionByQrCodeRepo
          .closePremiumSessionByQrCodeRepo(event.qrCode);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionClosingPremiumSessionByQrCode(
                message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionClosingPremiumSessionByQrCode(
                message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenClosingPremiumSessionByQrCode(
                message: failure.message));
            break;
          default:
            emit(ExceptionClosingPremiumSessionByQrCode(
                message: "Unknown error occurred"));
        }
      }, (response) {
        emit(SuccessClosingPremiumSessionByQrCode(response: response));
      });
    });
  }
}
