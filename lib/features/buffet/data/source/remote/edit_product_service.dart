import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';

class EditProductService extends Service {
  EditProductService({required super.dio});

  Future<Response> editProductService(ProductModel product, String id) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.put(
        "$baseUrl/api/v1/products/$id",
        options: getOptions(auth: true),
        data: product.toMap(),
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
