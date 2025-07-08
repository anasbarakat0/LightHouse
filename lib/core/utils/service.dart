// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  final Dio dio;

  late Response response;

  Service({required this.dio}) {
    // Attach logging interceptor (for debugging API requests)
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("🔹 API Request: ${options.method} ${options.uri}");
        print("Headers: ${options.headers}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("✅ API Response [${response.statusCode}]: ${response.requestOptions.uri}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("❌ API Error: ${e.requestOptions.uri}");
        print("Error Message: ${e.message}");
        return handler.next(e);
      },
    ));
  }

  Options getOptions({bool auth = false}) {
    final sharedPrefs = memory.get<SharedPreferences>();
    final String? token = sharedPrefs.getString("token");

    Map<String, String> headers = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };

    if (auth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return Options(headers: headers);
  }
}
