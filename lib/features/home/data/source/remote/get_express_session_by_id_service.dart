import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetExpressSessionByIdService extends Service {
  GetExpressSessionByIdService({required super.dio});

  Future<Response> getExpressSessionByIdService(String id) async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/sessions/express/$id",
        options: options(true),
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
