// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DashboardAlertsResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final AlertsBody body;

  DashboardAlertsResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory DashboardAlertsResponseModel.fromMap(Map<String, dynamic> map) {
    return DashboardAlertsResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: AlertsBody.fromMap(map['body'] as Map<String, dynamic>),
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

  factory DashboardAlertsResponseModel.fromJson(String source) =>
      DashboardAlertsResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AlertsBody {
  final int totalAlerts;
  final List<Alert> alerts;

  AlertsBody({
    required this.totalAlerts,
    required this.alerts,
  });

  factory AlertsBody.fromMap(Map<String, dynamic> map) {
    return AlertsBody(
      totalAlerts: map['totalAlerts'] as int? ?? 0,
      alerts: (map['alerts'] as List<dynamic>?)
              ?.map((x) => Alert.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalAlerts': totalAlerts,
      'alerts': alerts.map((x) => x.toMap()).toList(),
    };
  }
}

class Alert {
  final String alertType;
  final String severity;
  final String title;
  final String message;
  final String? sessionId;
  final String timestamp;

  Alert({
    required this.alertType,
    required this.severity,
    required this.title,
    required this.message,
    this.sessionId,
    required this.timestamp,
  });

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      alertType: map['alertType'] as String? ?? '',
      severity: map['severity'] as String? ?? 'INFO',
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      sessionId: map['sessionId'] as String?,
      timestamp: map['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alertType': alertType,
      'severity': severity,
      'title': title,
      'message': message,
      'sessionId': sessionId,
      'timestamp': timestamp,
    };
  }
}

