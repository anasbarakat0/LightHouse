import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class VerifyQrCodeService extends Service {
  VerifyQrCodeService({required super.dio});

  Future<Response> verifyQrCodeService(String qrCode) async {
    try {
      print("🔹 Verifying QR Code: $qrCode");
      print("🔹 URL: $baseUrl/api/qr-code/verify/$qrCode");
      response = await dio.get(
        "$baseUrl/api/qr-code/verify/$qrCode",
        options: getOptions(auth: true),
      );
      print("✅ Successfully verified QR Code");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data["status"] == "BAD_REQUEST") {
          print("BAD_REQUEST in VerifyQrCodeService");
          throw BAD_REQUEST.fromMap(e.response!.data);
        } else if (e.response!.data['status'] == 403 ||
            e.response!.statusCode == 403) {
          print("Forbidden in VerifyQrCodeService");
          throw Forbidden();
        }
      }
      print("DioException in VerifyQrCodeService: ${e.message}");
      rethrow;
    }
  }
}

