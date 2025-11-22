import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class DeleteCouponService extends Service {
  DeleteCouponService({required super.dio});

  Future<Response> deleteCoupon(String couponId) async {
    try {
      response = await dio.delete(
        "$baseUrl/api/v1/coupons/$couponId",
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

