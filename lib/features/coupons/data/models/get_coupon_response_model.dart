// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:lighthouse/features/coupons/data/models/coupon_model.dart';

class GetCouponResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final CouponModel body;

  GetCouponResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  GetCouponResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    CouponModel? body,
  }) {
    return GetCouponResponseModel(
      message: message ?? this.message,
      status: status ?? this.status,
      localDateTime: localDateTime ?? this.localDateTime,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'localDateTime': localDateTime,
      'body': body.toMap(),
    };
  }

  factory GetCouponResponseModel.fromMap(Map<String, dynamic> map) {
    return GetCouponResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: CouponModel.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetCouponResponseModel.fromJson(String source) =>
      GetCouponResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetCouponResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant GetCouponResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status == status &&
        other.localDateTime == localDateTime &&
        other.body == body;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        status.hashCode ^
        localDateTime.hashCode ^
        body.hashCode;
  }
}

