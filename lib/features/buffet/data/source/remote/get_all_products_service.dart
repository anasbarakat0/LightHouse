import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';

class GetAllProductsService extends Service {
  GetAllProductsService({required super.dio});

  Future<Response> getAllProductsService(int page, int size) async {
    try {
      // final result = await Isolate.run(() async {
        response = await dio.get(
          "$baseUrl/api/products/all?page=$page&size=$size",
          options: getOptions(auth: false),
        );
        if (response.data["body"] == []) {
          throw NoData(message: "No product to show");
        } else {
          return response;
        }
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
