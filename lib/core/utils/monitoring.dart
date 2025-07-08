import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("🔹 Request Sent: ${options.method} ${options.uri}");
    print("Headers: ${options.headers}");
    print("Body: ${options.data}");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("✅ Response Received: ${response.requestOptions.uri}");
    print("Status Code: ${response.statusCode}");
    print("Response Data: ${response.data}");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("❌ API Error: ${err.requestOptions.uri}");
    print("Error Message: ${err.message}");
    handler.next(err);
  }
}

