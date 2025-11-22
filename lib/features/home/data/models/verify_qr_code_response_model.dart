// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VerifyQrCodeResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final VerifyQrCodeBody body;

  VerifyQrCodeResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  VerifyQrCodeResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    VerifyQrCodeBody? body,
  }) {
    return VerifyQrCodeResponseModel(
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

  factory VerifyQrCodeResponseModel.fromMap(Map<String, dynamic> map) {
    return VerifyQrCodeResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: VerifyQrCodeBody.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyQrCodeResponseModel.fromJson(String source) =>
      VerifyQrCodeResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VerifyQrCodeResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant VerifyQrCodeResponseModel other) {
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

class VerifyQrCodeBody {
  final String? uuid;
  final String qrCode;
  final String qrCodeType;
  final String createdAt;

  VerifyQrCodeBody({
    this.uuid,
    required this.qrCode,
    required this.qrCodeType,
    required this.createdAt,
  });

  VerifyQrCodeBody copyWith({
    String? uuid,
    String? qrCode,
    String? qrCodeType,
    String? createdAt,
  }) {
    return VerifyQrCodeBody(
      uuid: uuid ?? this.uuid,
      qrCode: qrCode ?? this.qrCode,
      qrCodeType: qrCodeType ?? this.qrCodeType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'qrCode': qrCode,
      'qrCodeType': qrCodeType,
      'createdAt': createdAt,
    };
  }

  factory VerifyQrCodeBody.fromMap(Map<String, dynamic> map) {
    return VerifyQrCodeBody(
      uuid: map['uuid'] as String?,
      qrCode: map['qrCode'] as String? ?? '',
      qrCodeType: map['qrCodeType'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyQrCodeBody.fromJson(String source) =>
      VerifyQrCodeBody.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VerifyQrCodeBody(uuid: $uuid, qrCode: $qrCode, qrCodeType: $qrCodeType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant VerifyQrCodeBody other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.qrCode == qrCode &&
        other.qrCodeType == qrCodeType &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        qrCode.hashCode ^
        qrCodeType.hashCode ^
        createdAt.hashCode;
  }
}

