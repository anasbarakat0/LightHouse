import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetCouponService extends Service {
  GetCouponService({required super.dio});

  Future<Response> getCoupon(String codeOrId) async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/coupons/$codeOrId",
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

