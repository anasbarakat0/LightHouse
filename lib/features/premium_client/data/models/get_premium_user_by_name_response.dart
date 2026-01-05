// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetPremiumUserByNameResponse {
  final String message;
  final String status;
  final String localDateTime;
  final List<PremiumUser> body;
  GetPremiumUserByNameResponse({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  GetPremiumUserByNameResponse copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<PremiumUser>? body,
  }) {
    return GetPremiumUserByNameResponse(
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

  factory GetPremiumUserByNameResponse.fromMap(Map<String, dynamic> map) {
    return GetPremiumUserByNameResponse(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: List<PremiumUser>.from(
          (map['body'] as List<dynamic>).map((x) => PremiumUser.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetPremiumUserByNameResponse.fromJson(String source) =>
      GetPremiumUserByNameResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GetPremiumUserByNameResponse(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
}

class PremiumUser {
  final String uuid;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String gender;
  final String? study;
  final dynamic birthDate;
  final String addingDateTime;
  final String addedBy;
  final QrCode qrCode;
  final String generatedPassword;
  PremiumUser({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    required this.gender,
    this.study,
    this.birthDate,
    required this.addingDateTime,
    required this.addedBy,
    required this.qrCode,
    required this.generatedPassword,
  });

  PremiumUser copyWith({
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
    String? generatedPassword,
  }) {
    return PremiumUser(
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
      generatedPassword: generatedPassword ?? this.generatedPassword,
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
      'generatedPassword': generatedPassword,
    };
  }

  factory PremiumUser.fromMap(Map<String, dynamic> map) {
    return PremiumUser(
      uuid: map['uuid'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      gender: map['gender'] as String? ?? '',
      study: map['study'] as String?,
      birthDate: map['birthDate'],
      addingDateTime: map['addingDateTime'] as String? ?? '',
      addedBy: map['addedBy'] as String? ?? '',
      qrCode: QrCode.fromMap(map['qrCode'] as Map<String, dynamic>),
      generatedPassword: map['generatedPassword'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PremiumUser.fromJson(String source) =>
      PremiumUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PremiumUser(uuid: $uuid, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, gender: $gender, study: $study, birthDate: $birthDate, addingDateTime: $addingDateTime, addedBy: $addedBy, qrCode: $qrCode, generatedPassword: $generatedPassword)';
  }

  @override
  bool operator ==(covariant PremiumUser other) {
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
        other.qrCode == qrCode &&
        other.generatedPassword == generatedPassword;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        (email?.hashCode ?? 0) ^
        (phoneNumber?.hashCode ?? 0) ^
        gender.hashCode ^
        (study?.hashCode ?? 0) ^
        (birthDate?.hashCode ?? 0) ^
        addingDateTime.hashCode ^
        addedBy.hashCode ^
        qrCode.hashCode ^
        generatedPassword.hashCode;
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
    this.lastModifiedBy,
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
    return QrCode(
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
      createdBy: map['createdBy'] as String? ?? '',
      lastModifiedBy: map['lastModifiedBy'],
      id: map['id'] as String? ?? '',
      qrCodeType: map['qrCodeType'] as String? ?? '',
      qrCode: map['qrCode'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QrCode.fromJson(String source) =>
      QrCode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QrCode(createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, id: $id, qrCodeType: $qrCodeType, qrCode: $qrCode)';
  }
}
