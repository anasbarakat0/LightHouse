// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DeleteCouponResponseModel {
  final String message;
  final String status;
  final String localDateTime;

  DeleteCouponResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
  });

  DeleteCouponResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
  }) {
    return DeleteCouponResponseModel(
      message: message ?? this.message,
      status: status ?? this.status,
      localDateTime: localDateTime ?? this.localDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'localDateTime': localDateTime,
    };
  }

  factory DeleteCouponResponseModel.fromMap(Map<String, dynamic> map) {
    return DeleteCouponResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeleteCouponResponseModel.fromJson(String source) =>
      DeleteCouponResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeleteCouponResponseModel(message: $message, status: $status, localDateTime: $localDateTime)';
  }

  @override
  bool operator ==(covariant DeleteCouponResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status == status &&
        other.localDateTime == localDateTime;
  }

  @override
  int get hashCode {
    return message.hashCode ^ status.hashCode ^ localDateTime.hashCode;
  }
}

