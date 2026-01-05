// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateCapacityResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final UpdateCapacityBody body;

  UpdateCapacityResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  UpdateCapacityResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    UpdateCapacityBody? body,
  }) {
    return UpdateCapacityResponseModel(
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

  factory UpdateCapacityResponseModel.fromMap(Map<String, dynamic> map) {
    return UpdateCapacityResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: UpdateCapacityBody.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateCapacityResponseModel.fromJson(String source) =>
      UpdateCapacityResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UpdateCapacityResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant UpdateCapacityResponseModel other) {
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

class UpdateCapacityBody {
  final int capacity;

  UpdateCapacityBody({
    required this.capacity,
  });

  UpdateCapacityBody copyWith({
    int? capacity,
  }) {
    return UpdateCapacityBody(
      capacity: capacity ?? this.capacity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'capacity': capacity,
    };
  }

  factory UpdateCapacityBody.fromMap(Map<String, dynamic> map) {
    return UpdateCapacityBody(
      capacity: (map['capacity'] as int?) ?? 100,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateCapacityBody.fromJson(String source) =>
      UpdateCapacityBody.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UpdateCapacityBody(capacity: $capacity)';
  }

  @override
  bool operator ==(covariant UpdateCapacityBody other) {
    if (identical(this, other)) return true;

    return other.capacity == capacity;
  }

  @override
  int get hashCode {
    return capacity.hashCode;
  }
}


