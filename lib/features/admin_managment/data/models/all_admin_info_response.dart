// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AllAdminInfoResponse {
  final String message;
  final String status;
  final String localDateTime;
  final List<Body> body;
  final Pageable pageable;
  AllAdminInfoResponse({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
    required this.pageable,
  });

  AllAdminInfoResponse copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<Body>? body,
    Pageable? pageable,
  }) {
    return AllAdminInfoResponse(
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

  factory AllAdminInfoResponse.fromMap(Map<String, dynamic> map) {
    print("1---------------------");
    return AllAdminInfoResponse(
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

  factory AllAdminInfoResponse.fromJson(String source) =>
      AllAdminInfoResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AllAdminInfoResponse(message: $message, status: $status, localDateTime: $localDateTime, body: $body, pageable: $pageable)';
  }

  @override
  bool operator ==(covariant AllAdminInfoResponse other) {
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
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  Body({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  Body copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
  }) {
    return Body(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    print("2---------------------");
    return Body(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) =>
      Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(id: $id, firstName: $firstName, lastName: $lastName, email: $email, role: $role)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        role.hashCode;
  }
}

class Pageable {
  final int page;
  final int perPage;
  Pageable({
    required this.page,
    required this.perPage,
  });

  Pageable copyWith({
    int? page,
    int? perPage,
  }) {
    return Pageable(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };
  }

  factory Pageable.fromMap(Map<String, dynamic> map) {
    print("3---------------------");
    return Pageable(
      page: map['page'] as int,
      perPage: map['perPage'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pageable.fromJson(String source) =>
      Pageable.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Pageable(page: $page, perPage: $perPage)';

  @override
  bool operator ==(covariant Pageable other) {
    if (identical(this, other)) return true;

    return other.page == page && other.perPage == perPage;
  }

  @override
  int get hashCode => page.hashCode ^ perPage.hashCode;
}
