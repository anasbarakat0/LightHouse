// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EditPackageInfoResponseModel {
    final String message;
    final String status;
    final String localDateTime;
    final Body body;
  EditPackageInfoResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  EditPackageInfoResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return EditPackageInfoResponseModel(
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

  factory EditPackageInfoResponseModel.fromMap(Map<String, dynamic> map) {
    return EditPackageInfoResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory EditPackageInfoResponseModel.fromJson(String source) => EditPackageInfoResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EditPackageInfoResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant EditPackageInfoResponseModel other) {
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
    final String id;
    final int numOfHours;
    final double price;
    final String description;
    final int packageDurationInDays;
    final bool active;
  Body({
    required this.id,
    required this.numOfHours,
    required this.price,
    required this.description,
    required this.packageDurationInDays,
    required this.active,
  });



  Body copyWith({
    String? id,
    int? numOfHours,
    double? price,
    String? description,
    int? packageDurationInDays,
    bool? active,
  }) {
    return Body(
      id: id ?? this.id,
      numOfHours: numOfHours ?? this.numOfHours,
      price: price ?? this.price,
      description: description ?? this.description,
      packageDurationInDays: packageDurationInDays ?? this.packageDurationInDays,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'numOfHours': numOfHours,
      'price': price,
      'description': description,
      'packageDurationInDays': packageDurationInDays,
      'active': active,
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    return Body(
      id: map['id'] as String,
      numOfHours: map['numOfHours'] as int,
      price: map['price'] as double,
      description: map['description'] as String,
      packageDurationInDays: map['packageDurationInDays'] as int,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(id: $id, numOfHours: $numOfHours, price: $price, description: $description, packageDurationInDays: $packageDurationInDays, active: $active)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.numOfHours == numOfHours &&
      other.price == price &&
      other.description == description &&
      other.packageDurationInDays == packageDurationInDays &&
      other.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      numOfHours.hashCode ^
      price.hashCode ^
      description.hashCode ^
      packageDurationInDays.hashCode ^
      active.hashCode;
  }
}
