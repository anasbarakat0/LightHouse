// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:lighthouse_/features/premium_client/domain/entity/NewPremiumClientResponseEntity.dart';

class NewPremiumClientResponseModel extends Newpremiumclientresponseentity {
  NewPremiumClientResponseModel({
    required super.message,
    required super.status,
    required super.localDateTime,
    required super.body,
  });

  @override
  NewPremiumClientResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return NewPremiumClientResponseModel(
      message: message ?? this.message,
      status: status ?? this.status,
      localDateTime: localDateTime ?? this.localDateTime,
      body: body ?? this.body,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'localDateTime': localDateTime,
      'body': body.toMap(),
    };
  }

  factory NewPremiumClientResponseModel.fromMap(Map<String, dynamic> map) {
    print("NewPremiumClientResponseModel");
    return NewPremiumClientResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory NewPremiumClientResponseModel.fromJson(String source) =>
      NewPremiumClientResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewPremiumClientResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant NewPremiumClientResponseModel other) {
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
