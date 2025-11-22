// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:lighthouse/features/statistics/data/models/statistics_overview_response_model.dart';

class StatisticsBuffetResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final BuffetStatistics body;

  StatisticsBuffetResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory StatisticsBuffetResponseModel.fromMap(Map<String, dynamic> map) {
    return StatisticsBuffetResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: BuffetStatistics.fromMap(map['body'] as Map<String, dynamic>),
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

  factory StatisticsBuffetResponseModel.fromJson(String source) =>
      StatisticsBuffetResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

