// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:lighthouse/features/statistics/data/models/statistics_overview_response_model.dart';

class StatisticsSessionsResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final SessionsStatistics body;

  StatisticsSessionsResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory StatisticsSessionsResponseModel.fromMap(Map<String, dynamic> map) {
    return StatisticsSessionsResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: SessionsStatistics.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status': status,
      'localDateTime': localDateTime,
      'body': body.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory StatisticsSessionsResponseModel.fromJson(String source) =>
      StatisticsSessionsResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

