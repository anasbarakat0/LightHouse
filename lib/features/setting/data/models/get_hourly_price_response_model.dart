// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetHourlyPriceResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final Body body;
  GetHourlyPriceResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  GetHourlyPriceResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return GetHourlyPriceResponseModel(
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

  factory GetHourlyPriceResponseModel.fromMap(Map<String, dynamic> map) {
    print("941576");
    return GetHourlyPriceResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetHourlyPriceResponseModel.fromJson(String source) => GetHourlyPriceResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetHourlyPriceResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant GetHourlyPriceResponseModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.message == message &&
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

class Body {
  final double hourlyPrice;
  Body({
    required this.hourlyPrice,
  });

  Body copyWith({
    double? hourlyPrice,
  }) {
    return Body(
      hourlyPrice: hourlyPrice ?? this.hourlyPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hourlyPrice': hourlyPrice,
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    print(154975);
    return Body(
      hourlyPrice: map['hourlyPrice'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Body(hourlyPrice: $hourlyPrice)';

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;
  
    return 
      other.hourlyPrice == hourlyPrice;
  }

  @override
  int get hashCode => hourlyPrice.hashCode;
}
