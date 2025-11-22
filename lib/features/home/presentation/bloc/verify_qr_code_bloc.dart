import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/verify_qr_code_response_model.dart';
import 'package:lighthouse/features/home/domain/usecase/verify_qr_code_usecase.dart';
import 'package:meta/meta.dart';

part 'verify_qr_code_event.dart';
part 'verify_qr_code_state.dart';

class VerifyQrCodeBloc extends Bloc<VerifyQrCodeEvent, VerifyQrCodeState> {
  final VerifyQrCodeUsecase verifyQrCodeUsecase;

  VerifyQrCodeBloc(this.verifyQrCodeUsecase) : super(VerifyQrCodeInitial()) {
    on<VerifyQrCode>((event, emit) async {
      emit(VerifyQrCodeLoading());
      var data = await verifyQrCodeUsecase.call(event.qrCode);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(VerifyQrCodeException(message: failure.message));
            break;
          case OfflineFailure():
            emit(VerifyQrCodeException(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(VerifyQrCodeForbidden(message: failure.message));
            break;
          default:
            emit(VerifyQrCodeException(message: "Unknown error"));
        }
      }, (response) {
        emit(VerifyQrCodeSuccess(response: response));
      });
    });
  }
}

