import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';

class GetAllActiveSessionsService extends Service {
  GetAllActiveSessionsService({required super.dio});

  Future<Response> getAllActiveSessionsService() async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/sessions/active-sessions",
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
