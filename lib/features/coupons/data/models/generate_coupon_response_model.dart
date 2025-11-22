// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lighthouse/features/coupons/data/models/coupon_model.dart';

class GenerateCouponResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final List<CouponModel> body;

  GenerateCouponResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  GenerateCouponResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<CouponModel>? body,
  }) {
    return GenerateCouponResponseModel(
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
      'body': body.map((x) => x.toMap()).toList(),
    };
  }

  factory GenerateCouponResponseModel.fromMap(Map<String, dynamic> map) {
    return GenerateCouponResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: List<CouponModel>.from(
        (map['body'] as List<dynamic>)
            .map<CouponModel>((x) => CouponModel.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GenerateCouponResponseModel.fromJson(String source) =>
      GenerateCouponResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GenerateCouponResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant GenerateCouponResponseModel other) {
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

