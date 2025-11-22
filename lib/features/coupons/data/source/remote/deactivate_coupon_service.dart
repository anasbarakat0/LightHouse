import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class DeactivateCouponService extends Service {
  DeactivateCouponService({required super.dio});

  Future<Response> deactivateCoupon(String couponId) async {
    try {
      response = await dio.put(
        "$baseUrl/api/v1/coupons/$couponId/deactivate",
        options: getOptions(auth: true),
      );
      return response;
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data["status"] == "BAD_REQUEST") {
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response?.data != null && e.response!.data['status'] == 403) {
        throw Forbidden();
      } else {
        rethrow;
      }
    }
  }
}

