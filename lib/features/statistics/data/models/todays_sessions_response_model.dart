// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lighthouse/features/premium_client/data/models/get_sessions_by_user_id_response_model.dart';

class TodaysSessionsResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final TodaysSessionsBody body;

  TodaysSessionsResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  TodaysSessionsResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    TodaysSessionsBody? body,
  }) {
    return TodaysSessionsResponseModel(
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

  factory TodaysSessionsResponseModel.fromMap(Map<String, dynamic> map) {
    return TodaysSessionsResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: TodaysSessionsBody.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory TodaysSessionsResponseModel.fromJson(String source) =>
      TodaysSessionsResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TodaysSessionsResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant TodaysSessionsResponseModel other) {
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

class TodaysSessionsBody {
  final PaginationResponse paginationResponse;
  final List<SessionItem> sessions;

  TodaysSessionsBody({
    required this.paginationResponse,
    required this.sessions,
  });

  TodaysSessionsBody copyWith({
    PaginationResponse? paginationResponse,
    List<SessionItem>? sessions,
  }) {
    return TodaysSessionsBody(
      paginationResponse: paginationResponse ?? this.paginationResponse,
      sessions: sessions ?? this.sessions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paginationResponse': paginationResponse.toMap(),
      'sessions': sessions.map((x) => x.toMap()).toList(),
    };
  }

  factory TodaysSessionsBody.fromMap(Map<String, dynamic> map) {
    // Support both old and new response formats
    final paginationMap = map['pagination'] ?? map['paginationResponse'];
    final sessionsList = map['premiumSessionList'] ?? map['sessions'] ?? [];

    return TodaysSessionsBody(
      paginationResponse: PaginationResponse.fromMap(
          paginationMap as Map<String, dynamic>),
      sessions: List<SessionItem>.from(
        (sessionsList as List<dynamic>)
            .map((x) => SessionItem.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TodaysSessionsBody.fromJson(String source) =>
      TodaysSessionsBody.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TodaysSessionsBody(paginationResponse: $paginationResponse, sessions: $sessions)';
  }

  @override
  bool operator ==(covariant TodaysSessionsBody other) {
    if (identical(this, other)) return true;

    return other.paginationResponse == paginationResponse &&
        listEquals(other.sessions, sessions);
  }

  @override
  int get hashCode {
    return paginationResponse.hashCode ^ sessions.hashCode;
  }
}

