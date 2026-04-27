import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lighthouse/features/home/data/models/get_premium_session_response.dart';

class BuffetOrderRequestModel {
  final String productId;
  final int quantity;

  const BuffetOrderRequestModel({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
    };
  }

  factory BuffetOrderRequestModel.fromMap(Map<String, dynamic> map) {
    return BuffetOrderRequestModel(
      productId: (map['product_id'] ?? map['productId'] ?? '').toString(),
      quantity: (map['quantity'] as num? ?? 0).toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BuffetOrderRequestModel.fromJson(String source) =>
      BuffetOrderRequestModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class BuffetOperationResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final dynamic body;

  const BuffetOperationResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    this.body,
  });

  factory BuffetOperationResponseModel.fromMap(Map<String, dynamic> map) {
    return BuffetOperationResponseModel(
      message: (map['message'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      localDateTime: (map['localDateTime'] ?? '').toString(),
      body: map['body'],
    );
  }
}

class PremiumBuffetInvoicesResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final List<BuffetInvoice> body;

  const PremiumBuffetInvoicesResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory PremiumBuffetInvoicesResponseModel.fromMap(Map<String, dynamic> map) {
    final dynamic rawBody = map['body'];
    List<dynamic> invoiceList = const [];

    if (rawBody is List) {
      invoiceList = rawBody;
    } else if (rawBody is Map<String, dynamic>) {
      final dynamic nestedInvoices =
          rawBody['buffetInvoices'] ?? rawBody['invoices'] ?? rawBody['data'];
      if (nestedInvoices is List) {
        invoiceList = nestedInvoices;
      }
    }

    return PremiumBuffetInvoicesResponseModel(
      message: (map['message'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      localDateTime: (map['localDateTime'] ?? '').toString(),
      body: invoiceList
          .whereType<Map<String, dynamic>>()
          .map(BuffetInvoice.fromMap)
          .toList(),
    );
  }

  @override
  bool operator ==(covariant PremiumBuffetInvoicesResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status == status &&
        other.localDateTime == localDateTime &&
        listEquals(other.body, body);
  }

  @override
  int get hashCode {
    return message.hashCode ^
        status.hashCode ^
        localDateTime.hashCode ^
        body.hashCode;
  }
}
