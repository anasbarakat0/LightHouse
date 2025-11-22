import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetAllCouponsService extends Service {
  GetAllCouponsService({required super.dio});

  Future<Response> getAllCoupons({
    int? page,
    int? size,
    bool? active,
    String? discountType,
    String? appliesTo,
    String? codeSubstring,
    String? sort,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      // Add page and size only if provided, otherwise use defaults (page=0, size=20)
      if (page != null) {
        queryParams['page'] = page;
      }
      if (size != null) {
        queryParams['size'] = size;
      }

      if (active != null) {
        queryParams['active'] = active;
      }
      if (discountType != null) {
        queryParams['discountType'] = discountType;
      }
      if (appliesTo != null) {
        queryParams['appliesTo'] = appliesTo;
      }
      if (codeSubstring != null && codeSubstring.isNotEmpty) {
        queryParams['codeSubstring'] = codeSubstring;
      }
      if (sort != null) {
        queryParams['sort'] = sort;
      }

      response = await dio.get(
        "$baseUrl/api/v1/coupons",
        queryParameters: queryParams,
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

