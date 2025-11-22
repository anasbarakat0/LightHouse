// import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class FinishExpressSessionsService extends Service {
  FinishExpressSessionsService({required super.dio});

  Future<Response> finishExpressSessionsService(
    String id, {
    String? discountCode,
    double? manualDiscountAmount,
    String? manualDiscountNote,
  }) async {
    try {
      // final result = await Isolate.run(() async {
      final Map<String, dynamic> data = {};

      if (discountCode != null && discountCode.isNotEmpty) {
        data['discountCode'] = discountCode;
      }

      if (manualDiscountAmount != null && manualDiscountAmount >= 0) {
        data['manualDiscountAmount'] = manualDiscountAmount;
      }

      if (manualDiscountNote != null && manualDiscountNote.isNotEmpty) {
        data['manualDiscountNote'] = manualDiscountNote;
      }

      response = await dio.put(
        "$baseUrl/api/v1/sessions/express/$id",
        data: data.isNotEmpty ? data : null,
        options: getOptions(auth: true),
      );

      return response;
// });
//       return result;
    } on DioException catch (e) {
      if (e.response!.data["status"] == "BAD_REQUEST") {
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        throw Forbidden();
      } else {
        rethrow;
      }
    }
  }
}
