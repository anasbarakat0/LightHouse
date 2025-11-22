import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/get_premium_session_response.dart';
import 'package:lighthouse/features/home/data/repository/get_premium_session_by_id_repo.dart';
import 'package:lighthouse/features/home/data/repository/get_premium_session_by_qr_code_repo.dart';
import 'package:meta/meta.dart';

part 'get_premium_session_event.dart';
part 'get_premium_session_state.dart';

class GetPremiumSessionBloc
    extends Bloc<GetPremiumSessionEvent, GetPremiumSessionState> {
  final GetPremiumSessionByIdRepo getPremiumSessionByIdRepo;
  final GetPremiumSessionByQrCodeRepo? getPremiumSessionByQrCodeRepo;

  GetPremiumSessionBloc(
    this.getPremiumSessionByIdRepo, {
    this.getPremiumSessionByQrCodeRepo,
  }) : super(GetPremiumSessionInitial()) {
    on<GetPremiumSession>((event, emit) async {
      var data =
          await getPremiumSessionByIdRepo.getPremiumSessionByIdRepo(event.id);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGettingSessionById(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGettingSessionById(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGettingSessionById(message: failure.message));
            break;
          default:
        }
      }, (response) {
        emit(SuccessGettingSessionById(response: response));
      });
    });

    on<GetPremiumSessionByQrCode>((event, emit) async {
      if (getPremiumSessionByQrCodeRepo == null) {
        emit(ExceptionGettingSessionById(
            message: "QR Code repository not available"));
        return;
      }
      var data = await getPremiumSessionByQrCodeRepo!
          .getPremiumSessionByQrCodeRepo(event.qrCode);
      data.fold((failure) {
        switch (failure) {
          case ServerFailure():
            emit(ExceptionGettingSessionById(message: failure.message));
            break;
          case OfflineFailure():
            emit(ExceptionGettingSessionById(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenGettingSessionById(message: failure.message));
            break;
          default:
        }
      }, (response) {
        emit(SuccessGettingSessionById(response: response));
      });
    });
  }
}
