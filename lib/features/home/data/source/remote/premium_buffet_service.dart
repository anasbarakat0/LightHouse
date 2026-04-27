import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
import 'package:lighthouse/features/home/data/models/buffet_order_request_model.dart';

class PremiumBuffetService extends Service {
  PremiumBuffetService({required super.dio});

  Future<Response> addOrdersToPremiumSessionService(
    String sessionId,
    List<BuffetOrderRequestModel> orders,
  ) async {
    try {
      response = await dio.post(
        "$baseUrl/api/v1/buffet-invoices/premium/$sessionId/orders",
        options: getOptions(auth: true),
        data: {
          'orders': orders.map((order) => order.toMap()).toList(),
        },
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<Response> createBuffetInvoiceByQrCodeService(
    String qrCode,
    List<BuffetOrderRequestModel> orders,
  ) async {
    try {
      response = await dio.post(
        "$baseUrl/api/v1/buffet-invoices/new",
        options: getOptions(auth: true),
        data: {
          'qrCode': qrCode,
          'orders': orders.map((order) => order.toMap()).toList(),
        },
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<Response> getPremiumBuffetInvoicesService(String sessionId) async {
    try {
      response = await dio.get(
        "$baseUrl/api/v1/buffet-invoices/premium/$sessionId",
        options: getOptions(auth: true),
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<Response> updateBuffetOrderService(
    String orderId,
    int quantity,
  ) async {
    try {
      response = await dio.put(
        "$baseUrl/api/v1/buffet-orders/$orderId",
        options: getOptions(auth: true),
        data: {'quantity': quantity},
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<Response> deleteBuffetOrderService(String orderId) async {
    try {
      response = await dio.delete(
        "$baseUrl/api/v1/buffet-orders/$orderId",
        options: getOptions(auth: true),
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Never _handleDioException(DioException e) {
    final response = e.response;
    final data = response?.data;

    if (response?.statusCode == 401 || response?.statusCode == 403) {
      throw Forbidden();
    }

    if (data is Map<String, dynamic>) {
      final status = data['status']?.toString();
      if (status == 'BAD_REQUEST' ||
          status == '400 BAD_REQUEST' ||
          response?.statusCode == 400) {
        throw BAD_REQUEST.fromMap(data);
      }
    }

    throw e;
  }
}
