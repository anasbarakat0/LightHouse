import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';

class DeleteProductService extends Service {
  DeleteProductService({required super.dio});
  
  Future<Response> deleteProductService(String id) async{
    try {
      // final result = await Isolate.run(() async {
      response = await dio.delete("$baseUrl/api/products/$id",options: getOptions(auth: true));
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