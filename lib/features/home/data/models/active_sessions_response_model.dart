// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ActiveSessionsResponseModel {
    final String message;
    final String status;
    final String localDateTime;
    final Body body;
  ActiveSessionsResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });



  ActiveSessionsResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return ActiveSessionsResponseModel(
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

  factory ActiveSessionsResponseModel.fromMap(Map<String, dynamic> map) {
    return ActiveSessionsResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ActiveSessionsResponseModel.fromJson(String source) => ActiveSessionsResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ActiveSessionsResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant ActiveSessionsResponseModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.message == message &&
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
    final List<ActivePremiumSession> activePremiumSessions;
    final List<ActiveExpressSession> activeExpressSessions;
  Body({
    required this.activePremiumSessions,
    required this.activeExpressSessions,
  });

   


  Body copyWith({
    List<ActivePremiumSession>? activePremiumSessions,
    List<ActiveExpressSession>? activeExpressSessions,
  }) {
    return Body(
      activePremiumSessions: activePremiumSessions ?? this.activePremiumSessions,
      activeExpressSessions: activeExpressSessions ?? this.activeExpressSessions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activePremiumSessions': activePremiumSessions.map((x) => x.toMap()).toList(),
      'activeExpressSessions': activeExpressSessions.map((x) => x.toMap()).toList(),
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    return Body(
      activePremiumSessions: List<ActivePremiumSession>.from((map['activePremiumSessions'] as List<dynamic>).map<ActivePremiumSession>((x) => ActivePremiumSession.fromMap(x as Map<String,dynamic>),),),
      activeExpressSessions: List<ActiveExpressSession>.from((map['activeExpressSessions'] as List<dynamic>).map<ActiveExpressSession>((x) => ActiveExpressSession.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Body(activePremiumSessions: $activePremiumSessions, activeExpressSessions: $activeExpressSessions)';

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.activePremiumSessions, activePremiumSessions) &&
      listEquals(other.activeExpressSessions, activeExpressSessions);
  }

  @override
  int get hashCode => activePremiumSessions.hashCode ^ activeExpressSessions.hashCode;
}

class ActiveExpressSession {
    final String id;
    final String date;
    final String startTime;
    final String qrCode;
    final CreatedBy createdBy;
    final String fullName;
    final SessionInvoice? sessionInvoice;
    final bool active;
  ActiveExpressSession({
    required this.id,
    required this.date,
    required this.startTime,
    required this.qrCode,
    required this.createdBy,
    required this.fullName,
    this.sessionInvoice,
    required this.active,
  });



  ActiveExpressSession copyWith({
    String? id,
    String? date,
    String? startTime,
    String? qrCode,
    CreatedBy? createdBy,
    String? fullName,
    SessionInvoice? sessionInvoice,
    bool? active,
  }) {
    return ActiveExpressSession(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      qrCode: qrCode ?? this.qrCode,
      createdBy: createdBy ?? this.createdBy,
      fullName: fullName ?? this.fullName,
      sessionInvoice: sessionInvoice ?? this.sessionInvoice,
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
      'sessionInvoice': sessionInvoice?.toMap(),
      'active': active,
    };
  }

  factory ActiveExpressSession.fromMap(Map<String, dynamic> map) {
    return ActiveExpressSession(
      id: map['id'] as String,
      date: map['date'] as String,
      startTime: map['startTime'] as String,
      qrCode: map['qrCode'] as String,
      createdBy: CreatedBy.fromMap(map['createdBy'] as Map<String,dynamic>),
      fullName: map['fullName'] as String,
      sessionInvoice: map['sessionInvoice'] != null
          ? SessionInvoice.fromMap(map['sessionInvoice'] as Map<String, dynamic>)
          : null,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActiveExpressSession.fromJson(String source) => ActiveExpressSession.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ActiveExpressSession(id: $id, date: $date, startTime: $startTime, qrCode: $qrCode, createdBy: $createdBy, fullName: $fullName, sessionInvoice: $sessionInvoice, active: $active)';
  }

  @override
  bool operator ==(covariant ActiveExpressSession other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.date == date &&
      other.startTime == startTime &&
      other.qrCode == qrCode &&
      other.createdBy == createdBy &&
      other.fullName == fullName &&
      other.sessionInvoice == sessionInvoice &&
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
      sessionInvoice.hashCode ^
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

  factory CreatedBy.fromJson(String source) => CreatedBy.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreatedBy(id: $id, firstName: $firstName, lastName: $lastName, email: $email, role: $role)';
  }

  @override
  bool operator ==(covariant CreatedBy other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
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

class ActivePremiumSession {
    final String id;
    final String date;
    final String startTime;
    final String qrCode;
    final CreatedBy createdBy;
    final String userId;
    final String firstName;
    final String lastName;
    final SessionInvoice? sessionInvoice;
    final bool active;
  ActivePremiumSession({
    required this.id,
    required this.date,
    required this.startTime,
    required this.qrCode,
    required this.createdBy,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.sessionInvoice,
    required this.active,
  });



  ActivePremiumSession copyWith({
    String? id,
    String? date,
    String? startTime,
    String? qrCode,
    CreatedBy? createdBy,
    String? userId,
    String? firstName,
    String? lastName,
    SessionInvoice? sessionInvoice,
    bool? active,
  }) {
    return ActivePremiumSession(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      qrCode: qrCode ?? this.qrCode,
      createdBy: createdBy ?? this.createdBy,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      sessionInvoice: sessionInvoice ?? this.sessionInvoice,
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
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'sessionInvoice': sessionInvoice?.toMap(),
      'active': active,
    };
  }

  factory ActivePremiumSession.fromMap(Map<String, dynamic> map) {
    return ActivePremiumSession(
      id: map['id'] as String,
      date: map['date'] as String,
      startTime: map['startTime'] as String,
      qrCode: map['qrCode'] as String,
      createdBy: CreatedBy.fromMap(map['createdBy'] as Map<String,dynamic>),
      userId: map['userId'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      sessionInvoice: map['sessionInvoice'] != null
          ? SessionInvoice.fromMap(map['sessionInvoice'] as Map<String, dynamic>)
          : null,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivePremiumSession.fromJson(String source) => ActivePremiumSession.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ActivePremiumSession(id: $id, date: $date, startTime: $startTime, qrCode: $qrCode, createdBy: $createdBy, userId: $userId, firstName: $firstName, lastName: $lastName, sessionInvoice: $sessionInvoice, active: $active)';
  }

  @override
  bool operator ==(covariant ActivePremiumSession other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.date == date &&
      other.startTime == startTime &&
      other.qrCode == qrCode &&
      other.createdBy == createdBy &&
      other.userId == userId &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.sessionInvoice == sessionInvoice &&
      other.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      qrCode.hashCode ^
      createdBy.hashCode ^
      userId.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      sessionInvoice.hashCode ^
      active.hashCode;
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
    // Handle hoursAmount conversion - support both int and double
    double hoursAmountValue = 0.0;
    if (map['hoursAmount'] != null) {
      if (map['hoursAmount'] is double) {
        hoursAmountValue = map['hoursAmount'] as double;
      } else if (map['hoursAmount'] is int) {
        hoursAmountValue = (map['hoursAmount'] as int).toDouble();
      } else if (map['hoursAmount'] is num) {
        hoursAmountValue = (map['hoursAmount'] as num).toDouble();
      } else {
        // Try to parse as string if needed
        try {
          hoursAmountValue = double.parse(map['hoursAmount'].toString());
        } catch (e) {
          hoursAmountValue = 0.0;
        }
      }
    }
    
    return SessionInvoice(
      id: map['id'] as String? ?? '',
      userType: map['userType'] as String? ?? '',
      session_id: map['session_id'] as String? ?? '',
      hoursAmount: hoursAmountValue,
      sessionPrice: () {
        double sessionPriceValue = 0.0;
        if (map['sessionPrice'] != null) {
          if (map['sessionPrice'] is double) {
            sessionPriceValue = map['sessionPrice'] as double;
          } else if (map['sessionPrice'] is int) {
            sessionPriceValue = (map['sessionPrice'] as int).toDouble();
          } else if (map['sessionPrice'] is num) {
            sessionPriceValue = (map['sessionPrice'] as num).toDouble();
          } else {
            try {
              sessionPriceValue = double.parse(map['sessionPrice'].toString());
            } catch (e) {
              sessionPriceValue = 0.0;
            }
          }
        }
        return sessionPriceValue;
      }(),
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
