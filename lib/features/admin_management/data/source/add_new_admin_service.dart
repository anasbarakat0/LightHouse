import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';
import 'package:lighthouse/features/admin_management/data/models/new_admin_model.dart';

class AddNewAdminService extends Service {
  AddNewAdminService({required super.dio});

  Future<Response> addNewAdminService(NewAdminModel admin) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.post(
        "$baseUrl/api/v1/dashboard/admins/newAdmin",
        options: getOptions(auth: true),
        data: admin.toMap(),
      );
        return response;
// });
//       return result;
    }on DioException  {
      rethrow;
    }
  }
}
