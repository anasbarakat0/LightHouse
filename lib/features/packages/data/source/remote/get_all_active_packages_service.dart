import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';

class GetAllActivePackagesService extends Service {
  GetAllActivePackagesService({required super.dio});

  Future<Response> getAllActivePackagesService(int page, int size) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.get(
        "$baseUrl/api/v1/packages?page=$page&size=$size",
        options: getOptions(auth: true),
      );
      print(true);
      return response;
// });
//       return result;
    } on DioException catch (e) {
      print("56 error");
      if (e.response!.data["status"] == "BAD_REQUEST") {
        print("238765");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        print("563675");
        throw Forbidden();
      } else {
        print("243897");
        rethrow;
      }
    }
  }
}
