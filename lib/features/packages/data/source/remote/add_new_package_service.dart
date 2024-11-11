import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/error/exception.dart';
import 'package:lighthouse_/core/utils/service.dart';
import 'package:lighthouse_/features/packages/data/models/edit_package_model.dart';

class AddNewPackageService extends Service {
  AddNewPackageService({required super.dio});

  Future<Response> addNewPackageService(PackageModel package) async {
    try {
      response = await dio.post(
        "$baseUrl/api/v1/packages",
        options: options(true),
        data: package.toMap(),
      );
      return response;
    }on DioException catch (e) {
       print("67 error");
      if (e.response!.data["status"] == "BAD_REQUEST") {
        print("835656");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        print("974566");
        throw Forbidden();
      } else {
        print("356865");
        rethrow;
      }
    }
  }
}
