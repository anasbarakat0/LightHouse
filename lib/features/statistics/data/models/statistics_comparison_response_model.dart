// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StatisticsComparisonResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final ComparisonBody body;

  StatisticsComparisonResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory StatisticsComparisonResponseModel.fromMap(Map<String, dynamic> map) {
    return StatisticsComparisonResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: ComparisonBody.fromMap(map['body'] as Map<String, dynamic>),
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

  factory StatisticsComparisonResponseModel.fromJson(String source) =>
      StatisticsComparisonResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ComparisonBody {
  final PeriodStatistics currentPeriod;
  final PeriodStatistics previousPeriod;
  final ChangeStatistics change;

  ComparisonBody({
    required this.currentPeriod,
    required this.previousPeriod,
    required this.change,
  });

  factory ComparisonBody.fromMap(Map<String, dynamic> map) {
    return ComparisonBody(
      currentPeriod: PeriodStatistics.fromMap(map['currentPeriod'] as Map<String, dynamic>),
      previousPeriod: PeriodStatistics.fromMap(map['previousPeriod'] as Map<String, dynamic>),
      change: ChangeStatistics.fromMap(map['change'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentPeriod': currentPeriod.toMap(),
      'previousPeriod': previousPeriod.toMap(),
      'change': change.toMap(),
    };
  }
}

class PeriodStatistics {
  final double revenue;
  final int sessions;
  final int users;
  final int newUsers;

  PeriodStatistics({
    required this.revenue,
    required this.sessions,
    required this.users,
    required this.newUsers,
  });

  factory PeriodStatistics.fromMap(Map<String, dynamic> map) {
    return PeriodStatistics(
      revenue: (map['revenue'] as num?)?.toDouble() ?? 0.0,
      sessions: map['sessions'] as int? ?? 0,
      users: map['users'] as int? ?? 0,
      newUsers: map['newUsers'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'revenue': revenue,
      'sessions': sessions,
      'users': users,
      'newUsers': newUsers,
    };
  }
}

class ChangeStatistics {
  final String revenueChange;
  final String sessionsChange;
  final String usersChange;
  final String newUsersChange;
  final double revenueChangeAmount;
  final int sessionsChangeAmount;
  final int usersChangeAmount;

  ChangeStatistics({
    required this.revenueChange,
    required this.sessionsChange,
    required this.usersChange,
    required this.newUsersChange,
    required this.revenueChangeAmount,
    required this.sessionsChangeAmount,
    required this.usersChangeAmount,
  });

  factory ChangeStatistics.fromMap(Map<String, dynamic> map) {
    return ChangeStatistics(
      revenueChange: map['revenueChange'] as String,
      sessionsChange: map['sessionsChange'] as String,
      usersChange: map['usersChange'] as String,
      newUsersChange: map['newUsersChange'] as String,
      revenueChangeAmount: (map['revenueChangeAmount'] as num?)?.toDouble() ?? 0.0,
      sessionsChangeAmount: map['sessionsChangeAmount'] as int? ?? 0,
      usersChangeAmount: map['usersChangeAmount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'revenueChange': revenueChange,
      'sessionsChange': sessionsChange,
      'usersChange': usersChange,
      'newUsersChange': newUsersChange,
      'revenueChangeAmount': revenueChangeAmount,
      'sessionsChangeAmount': sessionsChangeAmount,
      'usersChangeAmount': usersChangeAmount,
    };
  }
}

