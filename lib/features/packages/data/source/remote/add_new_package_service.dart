import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';
import 'package:lighthouse/features/packages/data/models/edit_package_model.dart';

class AddNewPackageService extends Service {
  AddNewPackageService({required super.dio});

  Future<Response> addNewPackageService(PackageModel package) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.post(
        "$baseUrl/api/v1/packages",
        options: getOptions(auth: true),
        data: package.toMap(),
      );
      return response;
// });
//       return result;
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
