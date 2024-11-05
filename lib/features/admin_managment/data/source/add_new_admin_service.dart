import 'package:dio/dio.dart';
import 'package:lighthouse_/core/constants/app_url.dart';
import 'package:lighthouse_/core/utils/service.dart';
import 'package:lighthouse_/features/admin_managment/data/models/new_admin_model.dart';

class AddNewAdminService extends Service {
  AddNewAdminService({required super.dio});

  Future<Response> addNewAdminService(NewAdminModel admin) async {
    try {
      response = await dio.post(
        "$baseUrl/api/v1/dashboard/admins/newAdmin",
        options: options(true),
        data: admin.toMap(),
      );
        return response;
    }on DioException  {
      rethrow;
    }
  }
}
