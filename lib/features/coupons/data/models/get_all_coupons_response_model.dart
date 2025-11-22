// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lighthouse/features/coupons/data/models/coupon_model.dart';

class GetAllCouponsResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final List<CouponModel> body;
  final Pageable pageable;

  GetAllCouponsResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
    required this.pageable,
  });

  GetAllCouponsResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<CouponModel>? body,
    Pageable? pageable,
  }) {
    return GetAllCouponsResponseModel(
      message: message ?? this.message,
      status: status ?? this.status,
      localDateTime: localDateTime ?? this.localDateTime,
      body: body ?? this.body,
      pageable: pageable ?? this.pageable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'localDateTime': localDateTime,
      'body': body.map((x) => x.toMap()).toList(),
      'pageable': pageable.toMap(),
    };
  }

  factory GetAllCouponsResponseModel.fromMap(Map<String, dynamic> map) {
    return GetAllCouponsResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: List<CouponModel>.from(
        (map['body'] as List<dynamic>)
            .map<CouponModel>((x) => CouponModel.fromMap(x as Map<String, dynamic>)),
      ),
      pageable: Pageable.fromMap(map['pageable'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAllCouponsResponseModel.fromJson(String source) =>
      GetAllCouponsResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetAllCouponsResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body, pageable: $pageable)';
  }

  @override
  bool operator ==(covariant GetAllCouponsResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status == status &&
        other.localDateTime == localDateTime &&
        listEquals(other.body, body) &&
        other.pageable == pageable;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        status.hashCode ^
        localDateTime.hashCode ^
        body.hashCode ^
        pageable.hashCode;
  }
}

class Pageable {
  final int page;
  final int perPage;
  final int total;

  Pageable({
    required this.page,
    required this.perPage,
    required this.total,
  });

  Pageable copyWith({
    int? page,
    int? perPage,
    int? total,
  }) {
    return Pageable(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'perPage': perPage,
      'total': total,
    };
  }

  factory Pageable.fromMap(Map<String, dynamic> map) {
    return Pageable(
      page: map['page'] as int,
      perPage: map['perPage'] as int,
      total: map['total'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pageable.fromJson(String source) =>
      Pageable.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Pageable(page: $page, perPage: $perPage, total: $total)';

  @override
  bool operator ==(covariant Pageable other) {
    if (identical(this, other)) return true;

    return other.page == page &&
        other.perPage == perPage &&
        other.total == total;
  }

  @override
  int get hashCode => page.hashCode ^ perPage.hashCode ^ total.hashCode;
}

