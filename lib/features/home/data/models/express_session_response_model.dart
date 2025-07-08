// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExpressSessionResponseModel {
    final String message;
    final String status;
    final String localDateTime;
    final Body body;
  ExpressSessionResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  ExpressSessionResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return ExpressSessionResponseModel(
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

  factory ExpressSessionResponseModel.fromMap(Map<String, dynamic> map) {
    return ExpressSessionResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpressSessionResponseModel.fromJson(String source) => ExpressSessionResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExpressSessionResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant ExpressSessionResponseModel other) {
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
    final String id;
    final String date;
    final String startTime;
    final String qrCode;
    final CreatedBy createdBy;
    final String fullName;
    final bool active;
  Body({
    required this.id,
    required this.date,
    required this.startTime,
    required this.qrCode,
    required this.createdBy,
    required this.fullName,
    required this.active,
  });

  Body copyWith({
    String? id,
    String? date,
    String? startTime,
    String? qrCode,
    CreatedBy? createdBy,
    String? fullName,
    bool? active,
  }) {
    return Body(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      qrCode: qrCode ?? this.qrCode,
      createdBy: createdBy ?? this.createdBy,
      fullName: fullName ?? this.fullName,
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
      'active': active,
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    return Body(
      id: map['id'] as String,
      date: map['date'] as String,
      startTime: map['startTime'] as String,
      qrCode: map['qrCode'] as String,
      createdBy: CreatedBy.fromMap(map['createdBy'] as Map<String,dynamic>),
      fullName: map['fullName'] as String,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(id: $id, date: $date, startTime: $startTime, qrCode: $qrCode, createdBy: $createdBy, fullName: $fullName, active: $active)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.date == date &&
      other.startTime == startTime &&
      other.qrCode == qrCode &&
      other.createdBy == createdBy &&
      other.fullName == fullName &&
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
