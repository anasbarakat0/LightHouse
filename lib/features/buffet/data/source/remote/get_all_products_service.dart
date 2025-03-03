import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetAllProductsService extends Service {
  GetAllProductsService({required super.dio});

  Future<Response> getAllProductsService(int page, int size) async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/products/all?page=$page&size=$size",
        options: options(false),
      );
      if (response.data["body"] == []) {
        throw NoData(message: "No product to show");
      } else {
        return response;
      }
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
