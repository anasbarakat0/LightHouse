import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';
import 'package:lighthouse/features/packages/data/models/edit_package_model.dart';

class EditPackageInfoService extends Service {
  EditPackageInfoService({required super.dio});

  Future<Response> editPackageInfoService(
      String id, PackageModel package) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.put("$baseUrl/api/v1/packages/$id",
          options: getOptions(auth: true), data: package.toMap());
          return response;
// });
//       return result;
    }on DioException catch (e) {
       print("15 error");
      if (e.response!.data["status"] == "BAD_REQUEST") {
        print("68128");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        print("345746");
        throw Forbidden();
      } else {
        print("90665");
        rethrow;
      }
    }
  }
}
