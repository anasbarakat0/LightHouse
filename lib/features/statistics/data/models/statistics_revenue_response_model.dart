// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:lighthouse/features/statistics/data/models/statistics_overview_response_model.dart';

class StatisticsRevenueResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final RevenueStatistics body;

  StatisticsRevenueResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory StatisticsRevenueResponseModel.fromMap(Map<String, dynamic> map) {
    return StatisticsRevenueResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: RevenueStatistics.fromMap(map['body'] as Map<String, dynamic>),
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

  factory StatisticsRevenueResponseModel.fromJson(String source) =>
      StatisticsRevenueResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

