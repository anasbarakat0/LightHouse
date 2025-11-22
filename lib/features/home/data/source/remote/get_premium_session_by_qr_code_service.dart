import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetPremiumSessionByQrCodeService extends Service {
  GetPremiumSessionByQrCodeService({required super.dio});

  Future<Response> getPremiumSessionByQrCodeService(String qrCode) async {
    try {
      print("🔹 Getting premium session with QR Code: $qrCode");
      print("🔹 URL: $baseUrl/api/v1/sessions/premium/qr-code/$qrCode");
      response = await dio.get(
        "$baseUrl/api/v1/sessions/premium/qr-code/$qrCode",
        options: getOptions(auth: true),
      );
      print("✅ Successfully got premium session");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data["status"] == "BAD_REQUEST") {
          print("BAD_REQUEST in GetPremiumSessionByQrCodeService");
          throw BAD_REQUEST.fromMap(e.response!.data);
        } else if (e.response!.data['status'] == 403 ||
            e.response!.statusCode == 403) {
          print("Forbidden in GetPremiumSessionByQrCodeService");
          throw Forbidden();
        }
      }
      print("DioException in GetPremiumSessionByQrCodeService: ${e.message}");
      rethrow;
    }
  }
}
