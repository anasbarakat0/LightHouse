// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DashboardSummaryResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final DashboardSummaryBody body;

  DashboardSummaryResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory DashboardSummaryResponseModel.fromMap(Map<String, dynamic> map) {
    return DashboardSummaryResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: DashboardSummaryBody.fromMap(map['body'] as Map<String, dynamic>),
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

  factory DashboardSummaryResponseModel.fromJson(String source) =>
      DashboardSummaryResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DashboardSummaryBody {
  final double todayRevenue;
  final double weekRevenue;
  final double monthRevenue;
  final int activeSessions;
  final int todaySessions;
  final int weekSessions;
  final int newUsersToday;
  final int newUsersWeek;
  final int newUsersMonth;
  final String todayRevenueGrowth;
  final String todaySessionsGrowth;
  final double averageSessionDurationToday;

  DashboardSummaryBody({
    required this.todayRevenue,
    required this.weekRevenue,
    required this.monthRevenue,
    required this.activeSessions,
    required this.todaySessions,
    required this.weekSessions,
    required this.newUsersToday,
    required this.newUsersWeek,
    required this.newUsersMonth,
    required this.todayRevenueGrowth,
    required this.todaySessionsGrowth,
    required this.averageSessionDurationToday,
  });

  factory DashboardSummaryBody.fromMap(Map<String, dynamic> map) {
    return DashboardSummaryBody(
      todayRevenue: (map['todayRevenue'] as num?)?.toDouble() ?? 0.0,
      weekRevenue: (map['weekRevenue'] as num?)?.toDouble() ?? 0.0,
      monthRevenue: (map['monthRevenue'] as num?)?.toDouble() ?? 0.0,
      activeSessions: map['activeSessions'] as int? ?? 0,
      todaySessions: map['todaySessions'] as int? ?? 0,
      weekSessions: map['weekSessions'] as int? ?? 0,
      newUsersToday: map['newUsersToday'] as int? ?? 0,
      newUsersWeek: map['newUsersWeek'] as int? ?? 0,
      newUsersMonth: map['newUsersMonth'] as int? ?? 0,
      todayRevenueGrowth: map['todayRevenueGrowth'] as String? ?? "+0.0%",
      todaySessionsGrowth: map['todaySessionsGrowth'] as String? ?? "+0.0%",
      averageSessionDurationToday: (map['averageSessionDurationToday'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todayRevenue': todayRevenue,
      'weekRevenue': weekRevenue,
      'monthRevenue': monthRevenue,
      'activeSessions': activeSessions,
      'todaySessions': todaySessions,
      'weekSessions': weekSessions,
      'newUsersToday': newUsersToday,
      'newUsersWeek': newUsersWeek,
      'newUsersMonth': newUsersMonth,
      'todayRevenueGrowth': todayRevenueGrowth,
      'todaySessionsGrowth': todaySessionsGrowth,
      'averageSessionDurationToday': averageSessionDurationToday,
    };
  }
}

