import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';
import 'package:lighthouse_/features/packages/data/models/edit_package_model.dart';

class EditPackageInfoService extends Service {
  EditPackageInfoService({required super.dio});

  Future<Response> editPackageInfoService(
      String id, PackageModel package) async {
    try {
      response = await dio.put("$baseUrl/api/v1/packages/$id",
          options: options(true), data: package.toMap());
print("156452341864534531384135435354");
          return response;
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
