// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:lighthouse/features/coupons/data/models/coupon_model.dart';

class DeactivateCouponResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final CouponModel body;

  DeactivateCouponResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  DeactivateCouponResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    CouponModel? body,
  }) {
    return DeactivateCouponResponseModel(
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

  factory DeactivateCouponResponseModel.fromMap(Map<String, dynamic> map) {
    return DeactivateCouponResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: CouponModel.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeactivateCouponResponseModel.fromJson(String source) =>
      DeactivateCouponResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeactivateCouponResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant DeactivateCouponResponseModel other) {
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

