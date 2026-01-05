// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetUsersByNameResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final List<UserByName>? body;
  final Pageable? pageable;

  GetUsersByNameResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    this.body,
    this.pageable,
  });

  GetUsersByNameResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    List<UserByName>? body,
    Pageable? pageable,
  }) {
    return GetUsersByNameResponseModel(
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
      'body': body?.map((x) => x.toMap()).toList(),
      'pageable': pageable?.toMap(),
    };
  }

  factory GetUsersByNameResponseModel.fromMap(Map<String, dynamic> map) {
    return GetUsersByNameResponseModel(
      message: map['message'] as String? ?? '',
      status: map['status'] as String? ?? '',
      localDateTime: map['localDateTime'] as String? ?? '',
      body: map['body'] != null
          ? List<UserByName>.from(
              (map['body'] as List<dynamic>).map<UserByName>(
                (x) => UserByName.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      pageable: map['pageable'] != null
          ? Pageable.fromMap(map['pageable'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetUsersByNameResponseModel.fromJson(String source) =>
      GetUsersByNameResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetUsersByNameResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body, pageable: $pageable)';
  }

  @override
  bool operator ==(covariant GetUsersByNameResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status == status &&
        other.localDateTime == localDateTime &&
        other.body == body &&
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

class UserByName {
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
  final QrCodeData? qrCode;
  final String generatedPassword;

  UserByName({
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
    this.qrCode,
    required this.generatedPassword,
  });

  UserByName copyWith({
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
    QrCodeData? qrCode,
    String? generatedPassword,
  }) {
    return UserByName(
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
      'qrCode': qrCode?.toMap(),
      'generatedPassword': generatedPassword,
    };
  }

  factory UserByName.fromMap(Map<String, dynamic> map) {
    return UserByName(
      uuid: (map['uuid'] ?? '').toString(),
      firstName: (map['firstName'] ?? '').toString(),
      lastName: (map['lastName'] ?? '').toString(),
      email: map['email'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      gender: (map['gender'] ?? '').toString(),
      study: map['study'] as String?,
      birthDate: map['birthDate'],
      addingDateTime: (map['addingDateTime'] ?? '').toString(),
      addedBy: (map['addedBy'] ?? '').toString(),
      qrCode: map['qrCode'] != null
          ? QrCodeData.fromMap(map['qrCode'] as Map<String, dynamic>)
          : null,
      generatedPassword: map['generatedPassword'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserByName.fromJson(String source) =>
      UserByName.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserByName(uuid: $uuid, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, gender: $gender, study: $study, birthDate: $birthDate, addingDateTime: $addingDateTime, addedBy: $addedBy, qrCode: $qrCode, generatedPassword: $generatedPassword)';
  }

  @override
  bool operator ==(covariant UserByName other) {
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
        (email?.hashCode ?? 0) ^
        (phoneNumber?.hashCode ?? 0) ^
        gender.hashCode ^
        (study?.hashCode ?? 0) ^
        (birthDate?.hashCode ?? 0) ^
        addingDateTime.hashCode ^
        addedBy.hashCode ^
        (qrCode?.hashCode ?? 0) ^
        generatedPassword.hashCode;
  }
}

class QrCodeData {
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final dynamic lastModifiedBy;
  final String id;
  final String qrCodeType;
  final String qrCode;

  QrCodeData({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.lastModifiedBy,
    required this.id,
    required this.qrCodeType,
    required this.qrCode,
  });

  QrCodeData copyWith({
    String? createdAt,
    String? updatedAt,
    String? createdBy,
    dynamic lastModifiedBy,
    String? id,
    String? qrCodeType,
    String? qrCode,
  }) {
    return QrCodeData(
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

  factory QrCodeData.fromMap(Map<String, dynamic> map) {
    return QrCodeData(
      createdAt: (map['createdAt'] ?? '').toString(),
      updatedAt: (map['updatedAt'] ?? '').toString(),
      createdBy: (map['createdBy'] ?? '').toString(),
      lastModifiedBy: map['lastModifiedBy'],
      id: (map['id'] ?? '').toString(),
      qrCodeType: (map['qrCodeType'] ?? '').toString(),
      qrCode: (map['qrCode'] ?? '').toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory QrCodeData.fromJson(String source) =>
      QrCodeData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QrCodeData(createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, id: $id, qrCodeType: $qrCodeType, qrCode: $qrCode)';
  }

  @override
  bool operator ==(covariant QrCodeData other) {
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
