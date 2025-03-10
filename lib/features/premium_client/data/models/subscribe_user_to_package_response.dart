import 'dart:convert';
import 'package:lighthouse/features/premium_client/data/models/get_all_active_packages_response.dart';

class SubscribeUserToPackageResponse {
  final String message;
  final String status;
  final String localDateTime;
  final ActivePackage body;

  SubscribeUserToPackageResponse({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  SubscribeUserToPackageResponse copyWith({
    String? message,
    String? status,
    String? localDateTime,
    ActivePackage? body,
  }) {
    return SubscribeUserToPackageResponse(
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

  factory SubscribeUserToPackageResponse.fromMap(Map<String, dynamic> map) {
    return SubscribeUserToPackageResponse(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: ActivePackage.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscribeUserToPackageResponse.fromJson(String source) =>
      SubscribeUserToPackageResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubscribeUserToPackageResponse(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }
}
