import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';

class AddProductService extends Service {
  AddProductService({required super.dio});

  Future<Response> addProductService(ProductModel product) async {
    try {
      response = await dio.post(
        "$baseUrl/api/v1/products/new",
        options: options(true),
        data: product.toMap(),
      );
      return response;
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
