import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/close_express_session_by_qr_code_response_model.dart';
import 'package:lighthouse/features/home/data/repository/close_express_session_by_qr_code_repo.dart';
import 'package:meta/meta.dart';

part 'close_express_session_by_qr_code_event.dart';
part 'close_express_session_by_qr_code_state.dart';

class CloseExpressSessionByQrCodeBloc extends Bloc<
    CloseExpressSessionByQrCodeEvent, CloseExpressSessionByQrCodeState> {
  final CloseExpressSessionByQrCodeRepo closeExpressSessionByQrCodeRepo;

  CloseExpressSessionByQrCodeBloc(this.closeExpressSessionByQrCodeRepo)
      : super(CloseExpressSessionByQrCodeInitial()) {
    on<CloseExpressSessionByQrCode>((event, emit) async {
      emit(LoadingClosingExpressSessionByQrCode());
      var data = await closeExpressSessionByQrCodeRepo
          .closeExpressSessionByQrCodeRepo(event.qrCode);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionClosingExpressSessionByQrCode(
                message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionClosingExpressSessionByQrCode(
                message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenClosingExpressSessionByQrCode(
                message: failure.message));
            break;
          default:
            emit(ExceptionClosingExpressSessionByQrCode(
                message: "Unknown error occurred"));
        }
      }, (response) {
        emit(SuccessClosingExpressSessionByQrCode(response: response));
      });
    });
  }
}
