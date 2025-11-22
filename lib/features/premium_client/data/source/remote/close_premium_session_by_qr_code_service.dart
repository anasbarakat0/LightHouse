import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class ClosePremiumSessionByQrCodeService extends Service {
  ClosePremiumSessionByQrCodeService({required super.dio});

  Future<Response> closePremiumSessionByQrCodeService(String qrCode) async {
    try {
      print("🔹 Closing premium session with QR Code: $qrCode");
      print(
          "🔹 URL: $baseUrl/api/v1/sessions/premium/close-by-qrCode?qrCode=$qrCode");
      response = await dio.put(
        "$baseUrl/api/v1/sessions/premium/close-by-qrCode",
        queryParameters: {"qrCode": qrCode},
        options: getOptions(auth: true),
      );
      print("✅ Successfully closed premium session");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data["status"] == "BAD_REQUEST") {
          print("BAD_REQUEST in ClosePremiumSessionByQrCodeService");
          throw BAD_REQUEST.fromMap(e.response!.data);
        } else if (e.response!.data['status'] == 403 ||
            e.response!.statusCode == 403) {
          print("Forbidden in ClosePremiumSessionByQrCodeService");
          throw Forbidden();
        }
      }
      print("DioException in ClosePremiumSessionByQrCodeService: ${e.message}");
      rethrow;
    }
  }
}
