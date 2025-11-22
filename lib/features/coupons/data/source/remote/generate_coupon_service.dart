import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
import 'package:lighthouse/features/coupons/data/models/generate_coupon_request_model.dart';

class GenerateCouponService extends Service {
  GenerateCouponService({required super.dio});

  Future<Response> generateCoupon(
      GenerateCouponRequestModel request) async {
    try {
      response = await dio.post(
        "$baseUrl/api/v1/coupons/generate",
        data: request.toMap(),
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

