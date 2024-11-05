// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Newpremiumclientresponseentity {
  final String message;
  final String status;
  final String localDateTime;
  final Body body;
  Newpremiumclientresponseentity({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  Newpremiumclientresponseentity copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return Newpremiumclientresponseentity(
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

  factory Newpremiumclientresponseentity.fromMap(Map<String, dynamic> map) {
    return Newpremiumclientresponseentity(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Newpremiumclientresponseentity.fromJson(String source) => Newpremiumclientresponseentity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Newpremiumclientresponseentity(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant Newpremiumclientresponseentity other) {
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
  final String uuid;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String study;
  final String? birthDate;
  final QrCode qrCode;
  Body({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.study,
    this.birthDate,
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
    String? birthDate,
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
      'qrCode': qrCode.toMap(),
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    return Body(
      uuid: map['uuid'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      gender: map['gender'] as String,
      study: map['study'] as String,
      birthDate: map['birthDate'] != null ? map['birthDate'] as String : null,
      qrCode: QrCode.fromMap(map['qrCode'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(uuid: $uuid, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, gender: $gender, study: $study, birthDate: $birthDate, qrCode: $qrCode)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.phoneNumber == phoneNumber &&
      other.gender == gender &&
      other.study == study &&
      other.birthDate == birthDate &&
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
      qrCode.hashCode;
  }
}

class QrCode {
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic createdBy;
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
    dynamic createdAt,
    dynamic updatedAt,
    dynamic createdBy,
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
    print("QrCode.fromMap");
    return QrCode(
      createdAt: map['createdAt'] as dynamic,
      updatedAt: map['updatedAt'] as dynamic,
      createdBy: map['createdBy'] as dynamic,
      lastModifiedBy: map['lastModifiedBy'] as dynamic,
      id: map['id'] as String,
      qrCodeType: map['qrCodeType'] as String,
      qrCode: map['qrCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QrCode.fromJson(String source) => QrCode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QrCode(createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, id: $id, qrCodeType: $qrCodeType, qrCode: $qrCode)';
  }

  @override
  bool operator ==(covariant QrCode other) {
    if (identical(this, other)) return true;
  
    return 
      other.createdAt == createdAt &&
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
