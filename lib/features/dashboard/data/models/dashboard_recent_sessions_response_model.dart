// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DashboardRecentSessionsResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final RecentSessionsBody body;

  DashboardRecentSessionsResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory DashboardRecentSessionsResponseModel.fromMap(Map<String, dynamic> map) {
    return DashboardRecentSessionsResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: RecentSessionsBody.fromMap(map['body'] as Map<String, dynamic>),
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

  factory DashboardRecentSessionsResponseModel.fromJson(String source) =>
      DashboardRecentSessionsResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RecentSessionsBody {
  final List<RecentSession> sessions;

  RecentSessionsBody({
    required this.sessions,
  });

  factory RecentSessionsBody.fromMap(Map<String, dynamic> map) {
    return RecentSessionsBody(
      sessions: (map['sessions'] as List<dynamic>?)
              ?.map((x) => RecentSession.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessions': sessions.map((x) => x.toMap()).toList(),
    };
  }
}

class RecentSession {
  final String sessionId;
  final String sessionType;
  final String userName;
  final String date;
  final String startTime;
  final String? endTime;
  final bool isActive;
  final double duration;
  final double totalRevenue;
  final double sessionPrice;
  final double buffetPrice;

  RecentSession({
    required this.sessionId,
    required this.sessionType,
    required this.userName,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.isActive,
    required this.duration,
    required this.totalRevenue,
    required this.sessionPrice,
    required this.buffetPrice,
  });

  factory RecentSession.fromMap(Map<String, dynamic> map) {
    return RecentSession(
      sessionId: map['sessionId'] as String? ?? '',
      sessionType: map['sessionType'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      date: map['date'] as String? ?? '',
      startTime: map['startTime'] as String? ?? '',
      endTime: map['endTime'] as String?,
      isActive: map['isActive'] as bool? ?? false,
      duration: (map['duration'] as num?)?.toDouble() ?? 0.0,
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      sessionPrice: (map['sessionPrice'] as num?)?.toDouble() ?? 0.0,
      buffetPrice: (map['buffetPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'sessionType': sessionType,
      'userName': userName,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
      'duration': duration,
      'totalRevenue': totalRevenue,
      'sessionPrice': sessionPrice,
      'buffetPrice': buffetPrice,
    };
  }
}

