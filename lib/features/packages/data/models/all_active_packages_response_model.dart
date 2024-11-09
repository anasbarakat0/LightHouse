// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AllActivePackagesResponseModel {}

class ActivePackages extends AllActivePackagesResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final List<Body> body;
  final Pageable pageable;
  ActivePackages({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
    required this.pageable,
  });

  ActivePackages copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<Body>? body,
    Pageable? pageable,
  }) {
    return ActivePackages(
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

  factory ActivePackages.fromMap(Map<String, dynamic> map) {
    return ActivePackages(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: List<Body>.from(
        (map['body'] as List<dynamic>).map<Body>(
          (x) => Body.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pageable: Pageable.fromMap(map['pageable'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivePackages.fromJson(String source) =>
      ActivePackages.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ActivePackages(message: $message, status: $status, localDateTime: $localDateTime, body: $body, pageable: $pageable)';
  }

  @override
  bool operator ==(covariant ActivePackages other) {
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

class NoActivePackages extends AllActivePackagesResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final List<dynamic> body;
  final Pageable pageable;
  NoActivePackages({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
    required this.pageable,
  });

  NoActivePackages copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<dynamic>? body,
    Pageable? pageable,
  }) {
    return NoActivePackages(
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
      'body': body,
      'pageable': pageable.toMap(),
    };
  }

  factory NoActivePackages.fromMap(Map<String, dynamic> map) {
    return NoActivePackages(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: List<dynamic>.from(
        (map['body'] as List<dynamic>),
      ),
      pageable: Pageable.fromMap(map['pageable'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoActivePackages.fromJson(String source) =>
      NoActivePackages.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NoActivePackages(message: $message, status: $status, localDateTime: $localDateTime, body: $body, pageable: $pageable)';
  }

  @override
  bool operator ==(covariant NoActivePackages other) {
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
  final int numOfHours;
  final double price;
  final String description;
  final int packageDurationInDays;
  final bool active;
  Body({
    required this.id,
    required this.numOfHours,
    required this.price,
    required this.description,
    required this.packageDurationInDays,
    required this.active,
  });

  Body copyWith({
    String? id,
    int? numOfHours,
    double? price,
    String? description,
    int? packageDurationInDays,
    bool? active,
  }) {
    return Body(
      id: id ?? this.id,
      numOfHours: numOfHours ?? this.numOfHours,
      price: price ?? this.price,
      description: description ?? this.description,
      packageDurationInDays:
          packageDurationInDays ?? this.packageDurationInDays,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'numOfHours': numOfHours,
      'price': price,
      'description': description,
      'packageDurationInDays': packageDurationInDays,
      'active': active,
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    return Body(
      id: map['id'] as String,
      numOfHours: map['numOfHours'] as int,
      price: map['price'] as double,
      description: map['description'] as String,
      packageDurationInDays: map['packageDurationInDays'] as int,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) =>
      Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(id: $id, numOfHours: $numOfHours, price: $price, description: $description, packageDurationInDays: $packageDurationInDays, active: $active)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.numOfHours == numOfHours &&
        other.price == price &&
        other.description == description &&
        other.packageDurationInDays == packageDurationInDays &&
        other.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        numOfHours.hashCode ^
        price.hashCode ^
        description.hashCode ^
        packageDurationInDays.hashCode ^
        active.hashCode;
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
