// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GetAllProductsResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final List<Body> body;
  final Pageable pageable;
  GetAllProductsResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
    required this.pageable,
  });

  GetAllProductsResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<Body>? body,
    Pageable? pageable,
  }) {
    return GetAllProductsResponseModel(
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

  factory GetAllProductsResponseModel.fromMap(Map<String, dynamic> map) {
    final dynamic rawBody = map['body'];
    List<dynamic> bodyList = const [];
    Map<String, dynamic>? pageableMap;
    if (rawBody is List) {
      bodyList = rawBody;
    } else if (rawBody is Map<String, dynamic>) {
      // Support API shape: { body: { products: [...], paginationResponse: {...} } }
      final dynamic content = rawBody['products'] ??
          rawBody['content'] ??
          rawBody['items'] ??
          rawBody['data'];
      if (content is List) bodyList = content;
      final dynamic pag = rawBody['paginationResponse'];
      if (pag is Map<String, dynamic>) pageableMap = pag;
    }

    // Fallback to top-level pageable if present
    pageableMap ??= map['pageable'] as Map<String, dynamic>?;

    return GetAllProductsResponseModel(
      message: (map['message'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      localDateTime: (map['localDateTime'] ?? '').toString(),
      body: bodyList
          .whereType<Map<String, dynamic>>()
          .map<Body>((x) => Body.fromMap(x))
          .toList(),
      pageable: pageableMap == null
          ? Pageable(page: 0, perPage: 0, total: 0)
          : Pageable.fromMap(pageableMap),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAllProductsResponseModel.fromJson(String source) =>
      GetAllProductsResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetAllProductsResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body, pageable: $pageable)';
  }

  @override
  bool operator ==(covariant GetAllProductsResponseModel other) {
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

class Body {
  final String id;
  final String name;
  final double costPrice;
  final int quantity;
  final double consumptionPrice;
  final String barCode;
  final String? shortCut;
  Body({
    required this.id,
    required this.name,
    required this.costPrice,
    required this.quantity,
    required this.consumptionPrice,
    required this.barCode,
    this.shortCut,
  });

  Body copyWith({
    String? id,
    String? name,
    double? costPrice,
    int? quantity,
    double? consumptionPrice,
    String? barCode,
    String? shortCut,
  }) {
    return Body(
      id: id ?? this.id,
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      consumptionPrice: consumptionPrice ?? this.consumptionPrice,
      barCode: barCode ?? this.barCode,
      shortCut: shortCut ?? this.shortCut,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'costPrice': costPrice,
      'quantity': quantity,
      'consumptionPrice': consumptionPrice,
      'barCode': barCode,
      'shortCut': shortCut,
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    final num costNum = (map['costPrice'] as num? ?? 0);
    final num consNum = (map['consumptionPrice'] as num? ?? 0);
    return Body(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      costPrice: costNum.toDouble(),
      quantity: (map['quantity'] as num? ?? 0).toInt(),
      consumptionPrice: consNum.toDouble(),
      barCode: (map['barCode'] ?? '').toString(),
      shortCut: map['shortCut']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) =>
      Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(id: $id, name: $name, costPrice: $costPrice, quantity: $quantity, consumptionPrice: $consumptionPrice, barCode: $barCode, shortCut: $shortCut)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.costPrice == costPrice &&
        other.quantity == quantity &&
        other.consumptionPrice == consumptionPrice &&
        other.barCode == barCode &&
        other.shortCut == shortCut;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        costPrice.hashCode ^
        quantity.hashCode ^
        consumptionPrice.hashCode ^
        barCode.hashCode ^
        shortCut.hashCode;
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
      page: (map['page'] as num? ?? 0).toInt(),
      perPage: (map['perPage'] as num? ?? 0).toInt(),
      total: (map['total'] as num? ?? 0).toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Pageable.fromJson(String source) =>
      Pageable.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Pageable(page: $page, perPage: $perPage, total: $total)';

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
