// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdminByIdResponseModel {
    final String message;
    final String status;
    final String localDateTime;
    final Body body;
  AdminByIdResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  AdminByIdResponseModel copyWith({
    String? message,
    String? status,
    String? localDateTime,
    Body? body,
  }) {
    return AdminByIdResponseModel(
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

  factory AdminByIdResponseModel.fromMap(Map<String, dynamic> map) {
    print(1);
    return AdminByIdResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: Body.fromMap(map['body'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminByIdResponseModel.fromJson(String source) => AdminByIdResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdminByIdResponseModel(message: $message, status: $status, localDateTime: $localDateTime, body: $body)';
  }

  @override
  bool operator ==(covariant AdminByIdResponseModel other) {
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
    final String firstName;
    final String lastName;
    final String email;
    final String role;
  Body({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });


  Body copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
  }) {
    return Body(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    print(2);
    return Body(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Body(id: $id, firstName: $firstName, lastName: $lastName, email: $email, role: $role)';
  }

  @override
  bool operator ==(covariant Body other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      role.hashCode;
  }
}
