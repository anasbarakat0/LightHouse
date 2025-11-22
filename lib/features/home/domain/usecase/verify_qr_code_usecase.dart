import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/home/data/models/verify_qr_code_response_model.dart';
import 'package:lighthouse/features/home/data/repository/verify_qr_code_repo.dart';

class VerifyQrCodeUsecase {
  final VerifyQrCodeRepo verifyQrCodeRepo;

  VerifyQrCodeUsecase({required this.verifyQrCodeRepo});

  Future<Either<Failures, VerifyQrCodeResponseModel>> call(String qrCode) async {
    return await verifyQrCodeRepo.verifyQrCodeRepo(qrCode);
  }
}

