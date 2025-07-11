
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
// import 'dart:isolate';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPremiumUserByNameService extends Service {
  GetPremiumUserByNameService({required super.dio});

  Future<Response> getPremiumUserByNameService(String name) async {
    try {
      // final result = await Isolate.run(() async {
      response = await dio.get(
        "$baseUrl/api/v1/dashboard/users/by-name?name=$name",
        options: Options(
          headers: {
            'Accept': '*/*',
            'Authorization':
                'Bearer  ${memory.get<SharedPreferences>().getString("token")} ',
            'Connection': 'keep-alive',
          },
        ),
      );
      return response;
// });
//       return result;
    } on DioException catch (e) {
      print("DioException");
      if (e.response!.data["status"] == "BAD_REQUEST") {
        print("BAD_REQUEST");
        throw BAD_REQUEST.fromMap(e.response!.data);
      } else if (e.response!.data['status'] == 403) {
        print("throw Forbidden");
        throw Forbidden();
      } else {
        print("rethrow");
        rethrow;
      }
    }
  }
}
