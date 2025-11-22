// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CloseExpressSessionByQrCodeResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final Body body;
  CloseExpressSessionByQrCodeResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  CloseExpressSessionByQrCodeResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return CloseExpressSessionByQrCodeResponseModel(
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

  factory CloseExpressSessionByQrCodeResponseModel.fromMap(
      Map<String, dynamic> map) {
    return CloseExpressSessionByQrCodeResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CloseExpressSessionByQrCodeResponseModel.fromJson(String source) =>
      CloseExpressSessionByQrCodeResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CloseExpressSessionByQrCodeResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant CloseExpressSessionByQrCodeResponseModel other) {
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

class Body {
  final String id;
  final String date;
  final String startTime;
  final String qrCode;
  final CreatedBy createdBy;
  final String fullName;
  final String endTime;
  final SessionInvoice sessionInvoice;
  final double buffetInvoicePrice;
  final List<dynamic> buffetInvoices;
  final double totalPrice;
  final bool active;
  Body({
    required this.id,
    required this.date,
    required this.startTime,
    required this.qrCode,
    required this.createdBy,
    required this.fullName,
    required this.endTime,
    required this.sessionInvoice,
    required this.buffetInvoicePrice,
    required this.buffetInvoices,
    required this.totalPrice,
    required this.active,
  });

  Body copyWith({
    String? id,
    String? date,
    String? startTime,
    String? qrCode,
    CreatedBy? createdBy,
    String? fullName,
    String? endTime,
    SessionInvoice? sessionInvoice,
    double? buffetInvoicePrice,
    List<dynamic>? buffetInvoices,
    double? totalPrice,
    bool? active,
  }) {
    return Body(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      qrCode: qrCode ?? this.qrCode,
      createdBy: createdBy ?? this.createdBy,
      fullName: fullName ?? this.fullName,
      endTime: endTime ?? this.endTime,
      sessionInvoice: sessionInvoice ?? this.sessionInvoice,
      buffetInvoicePrice: buffetInvoicePrice ?? this.buffetInvoicePrice,
      buffetInvoices: buffetInvoices ?? this.buffetInvoices,
      totalPrice: totalPrice ?? this.totalPrice,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'startTime': startTime,
      'qrCode': qrCode,
      'createdBy': createdBy.toMap(),
      'fullName': fullName,
      'endTime': endTime,
      'sessionInvoice': sessionInvoice.toMap(),
      'buffetInvoicePrice': buffetInvoicePrice,
      'buffetInvoices': buffetInvoices,
      'totalPrice': totalPrice,
      'active': active,
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    return Body(
      id: map['id'] as String,
      date: map['date'] as String,
      startTime: map['startTime'] as String,
      qrCode: map['qrCode'] as String,
      createdBy: CreatedBy.fromMap(map['createdBy'] as Map<String, dynamic>),
      fullName: map['fullName'] as String,
      endTime: map['endTime'] as String,
      sessionInvoice:
          SessionInvoice.fromMap(map['sessionInvoice'] as Map<String, dynamic>),
      buffetInvoicePrice: map['buffetInvoicePrice'] as double,
      buffetInvoices: List<dynamic>.from(
        (map['buffetInvoices'] as List<dynamic>),
      ),
      totalPrice: map['totalPrice'] as double,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) =>
      Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(id: $id, date: $date, startTime: $startTime, qrCode: $qrCode, createdBy: $createdBy, fullName: $fullName, endTime: $endTime, sessionInvoice: $sessionInvoice, buffetInvoicePrice: $buffetInvoicePrice, buffetInvoices: $buffetInvoices, totalPrice: $totalPrice, active: $active)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.startTime == startTime &&
        other.qrCode == qrCode &&
        other.createdBy == createdBy &&
        other.fullName == fullName &&
        other.endTime == endTime &&
        other.sessionInvoice == sessionInvoice &&
        other.buffetInvoicePrice == buffetInvoicePrice &&
        listEquals(other.buffetInvoices, buffetInvoices) &&
        other.totalPrice == totalPrice &&
        other.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        startTime.hashCode ^
        qrCode.hashCode ^
        createdBy.hashCode ^
        fullName.hashCode ^
        endTime.hashCode ^
        sessionInvoice.hashCode ^
        buffetInvoicePrice.hashCode ^
        buffetInvoices.hashCode ^
        totalPrice.hashCode ^
        active.hashCode;
  }
}

class CreatedBy {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  CreatedBy copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
  }) {
    return CreatedBy(
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

  factory CreatedBy.fromMap(Map<String, dynamic> map) {
    return CreatedBy(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatedBy.fromJson(String source) =>
      CreatedBy.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreatedBy(id: $id, firstName: $firstName, lastName: $lastName, email: $email, role: $role)';
  }

  @override
  bool operator ==(covariant CreatedBy other) {
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

class SessionInvoice {
  final String id;
  final String userType;
  final String session_id;
  final double hoursAmount;
  final double sessionPrice;
  SessionInvoice({
    required this.id,
    required this.userType,
    required this.session_id,
    required this.hoursAmount,
    required this.sessionPrice,
  });

  SessionInvoice copyWith({
    String? id,
    String? userType,
    String? session_id,
    double? hoursAmount,
    double? sessionPrice,
  }) {
    return SessionInvoice(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      session_id: session_id ?? this.session_id,
      hoursAmount: hoursAmount ?? this.hoursAmount,
      sessionPrice: sessionPrice ?? this.sessionPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userType': userType,
      'session_id': session_id,
      'hoursAmount': hoursAmount,
      'sessionPrice': sessionPrice,
    };
  }

  factory SessionInvoice.fromMap(Map<String, dynamic> map) {
    return SessionInvoice(
      id: map['id'] as String,
      userType: map['userType'] as String,
      session_id: map['session_id'] as String,
      hoursAmount: map['hoursAmount'] as double,
      sessionPrice: map['sessionPrice'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionInvoice.fromJson(String source) =>
      SessionInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SessionInvoice(id: $id, userType: $userType, session_id: $session_id, hoursAmount: $hoursAmount, sessionPrice: $sessionPrice)';
  }

  @override
  bool operator ==(covariant SessionInvoice other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userType == userType &&
        other.session_id == session_id &&
        other.hoursAmount == hoursAmount &&
        other.sessionPrice == sessionPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userType.hashCode ^
        session_id.hashCode ^
        hoursAmount.hashCode ^
        sessionPrice.hashCode;
  }
}
