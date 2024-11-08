// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GetPremiumResponse {}

class GetAllPremiumclientResponseModel extends GetPremiumResponse {
  final String message;
  final String status;
  final String localDateTime;
  final List<Body> body;
  final Pageable pageable;
  GetAllPremiumclientResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
    required this.pageable,
  });

  GetAllPremiumclientResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<Body>? body,
    Pageable? pageable,
  }) {
    return GetAllPremiumclientResponseModel(
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

  factory GetAllPremiumclientResponseModel.fromMap(Map<String, dynamic> map) {
    print("68715");
    print(map);
    return GetAllPremiumclientResponseModel(
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

  factory GetAllPremiumclientResponseModel.fromJson(String source) =>
      GetAllPremiumclientResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetAllPremiumclientResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body, pageable: $pageable)';
  }

  @override
  bool operator ==(covariant GetAllPremiumclientResponseModel other) {
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
  final String uuid;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String study;
  final dynamic birthDate;
  final String addingDateTime;
  final String addedBy;
  final QrCode qrCode;
  Body({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.study,
    required this.birthDate,
    required this.addingDateTime,
    required this.addedBy,
    required this.qrCode,
  });

  Body copyWith({
    String? uuid,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? study,
    dynamic birthDate,
    String? addingDateTime,
    String? addedBy,
    QrCode? qrCode,
  }) {
    return Body(
      uuid: uuid ?? this.uuid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      study: study ?? this.study,
      birthDate: birthDate ?? this.birthDate,
      addingDateTime: addingDateTime ?? this.addingDateTime,
      addedBy: addedBy ?? this.addedBy,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'study': study,
      'birthDate': birthDate,
      'addingDateTime': addingDateTime,
      'addedBy': addedBy,
      'qrCode': qrCode.toMap(),
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    print("68745");
    return Body(
      uuid: map['uuid'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      gender: map['gender'] as String,
      study: map['study'] as String,
      birthDate: map['birthDate'] as dynamic,
      addingDateTime: map['addingDateTime'] as String,
      addedBy: map['addedBy'] as String,
      qrCode: QrCode.fromMap(map['qrCode'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) =>
      Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(uuid: $uuid, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, gender: $gender, study: $study, birthDate: $birthDate, addingDateTime: $addingDateTime, addedBy: $addedBy, qrCode: $qrCode)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender &&
        other.study == study &&
        other.birthDate == birthDate &&
        other.addingDateTime == addingDateTime &&
        other.addedBy == addedBy &&
        other.qrCode == qrCode;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        gender.hashCode ^
        study.hashCode ^
        birthDate.hashCode ^
        addingDateTime.hashCode ^
        addedBy.hashCode ^
        qrCode.hashCode;
  }
}

class QrCode {
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final dynamic lastModifiedBy;
  final String id;
  final String qrCodeType;
  final String qrCode;
  QrCode({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.id,
    required this.qrCodeType,
    required this.qrCode,
  });

  QrCode copyWith({
    String? createdAt,
    String? updatedAt,
    String? createdBy,
    dynamic lastModifiedBy,
    String? id,
    String? qrCodeType,
    String? qrCode,
  }) {
    return QrCode(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      id: id ?? this.id,
      qrCodeType: qrCodeType ?? this.qrCodeType,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'id': id,
      'qrCodeType': qrCodeType,
      'qrCode': qrCode,
    };
  }

  factory QrCode.fromMap(Map<String, dynamic> map) {
    print("68345");
    return QrCode(
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      createdBy: map['createdBy'] as String,
      lastModifiedBy: map['lastModifiedBy'] as dynamic,
      id: map['id'] as String,
      qrCodeType: map['qrCodeType'] as String,
      qrCode: map['qrCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QrCode.fromJson(String source) =>
      QrCode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QrCode(createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, id: $id, qrCodeType: $qrCodeType, qrCode: $qrCode)';
  }

  @override
  bool operator ==(covariant QrCode other) {
    if (identical(this, other)) return true;

    return other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.createdBy == createdBy &&
        other.lastModifiedBy == lastModifiedBy &&
        other.id == id &&
        other.qrCodeType == qrCodeType &&
        other.qrCode == qrCode;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        updatedAt.hashCode ^
        createdBy.hashCode ^
        lastModifiedBy.hashCode ^
        id.hashCode ^
        qrCodeType.hashCode ^
        qrCode.hashCode;
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
    print(map);
    print("89745");
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
