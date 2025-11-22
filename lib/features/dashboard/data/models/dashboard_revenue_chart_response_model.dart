// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DashboardRevenueChartResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final RevenueChartBody body;

  DashboardRevenueChartResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory DashboardRevenueChartResponseModel.fromMap(Map<String, dynamic> map) {
    return DashboardRevenueChartResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: RevenueChartBody.fromMap(map['body'] as Map<String, dynamic>),
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

  factory DashboardRevenueChartResponseModel.fromJson(String source) =>
      DashboardRevenueChartResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RevenueChartBody {
  final String period;
  final List<RevenueDataPoint> dataPoints;

  RevenueChartBody({
    required this.period,
    required this.dataPoints,
  });

  factory RevenueChartBody.fromMap(Map<String, dynamic> map) {
    return RevenueChartBody(
      period: map['period'] as String? ?? 'daily',
      dataPoints: (map['dataPoints'] as List<dynamic>?)
              ?.map((x) => RevenueDataPoint.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'period': period,
      'dataPoints': dataPoints.map((x) => x.toMap()).toList(),
    };
  }
}

class RevenueDataPoint {
  final String label;
  final double revenue;
  final double sessionRevenue;
  final double buffetRevenue;
  final double? packagesRevenue;
  final int sessions;

  RevenueDataPoint({
    required this.label,
    required this.revenue,
    required this.sessionRevenue,
    required this.buffetRevenue,
    this.packagesRevenue,
    required this.sessions,
  });

  factory RevenueDataPoint.fromMap(Map<String, dynamic> map) {
    return RevenueDataPoint(
      label: map['label'] as String? ?? '',
      revenue: (map['revenue'] as num?)?.toDouble() ?? 0.0,
      sessionRevenue: (map['sessionRevenue'] as num?)?.toDouble() ?? 0.0,
      buffetRevenue: (map['buffetRevenue'] as num?)?.toDouble() ?? 0.0,
      packagesRevenue: (map['packagesRevenue'] as num?)?.toDouble(),
      sessions: map['sessions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'revenue': revenue,
      'sessionRevenue': sessionRevenue,
      'buffetRevenue': buffetRevenue,
      'packagesRevenue': packagesRevenue,
      'sessions': sessions,
    };
  }
}

