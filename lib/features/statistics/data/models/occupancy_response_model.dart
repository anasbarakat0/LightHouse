// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OccupancyResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final OccupancyBody body;

  OccupancyResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  OccupancyResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    OccupancyBody? body,
  }) {
    return OccupancyResponseModel(
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

  factory OccupancyResponseModel.fromMap(Map<String, dynamic> map) {
    return OccupancyResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: OccupancyBody.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory OccupancyResponseModel.fromJson(String source) =>
      OccupancyResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OccupancyResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant OccupancyResponseModel other) {
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

class OccupancyBody {
  final int onGround;
  final int visits;
  final int capacity;

  OccupancyBody({
    required this.onGround,
    required this.visits,
    required this.capacity,
  });

  OccupancyBody copyWith({
    int? onGround,
    int? visits,
    int? capacity,
  }) {
    return OccupancyBody(
      onGround: onGround ?? this.onGround,
      visits: visits ?? this.visits,
      capacity: capacity ?? this.capacity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'onGround': onGround,
      'visits': visits,
      'capacity': capacity,
    };
  }

  factory OccupancyBody.fromMap(Map<String, dynamic> map) {
    return OccupancyBody(
      onGround: (map['onGround'] as int?) ?? 0,
      visits: (map['visits'] as int?) ?? 0,
      capacity: (map['capacity'] as int?) ?? 100,
    );
  }

  String toJson() => json.encode(toMap());

  factory OccupancyBody.fromJson(String source) =>
      OccupancyBody.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OccupancyBody(onGround: $onGround, visits: $visits, capacity: $capacity)';
  }

  @override
  bool operator ==(covariant OccupancyBody other) {
    if (identical(this, other)) return true;

    return other.onGround == onGround &&
        other.visits == visits &&
        other.capacity == capacity;
  }

  @override
  int get hashCode {
    return onGround.hashCode ^ visits.hashCode ^ capacity.hashCode;
  }
}


