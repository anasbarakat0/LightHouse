// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:lighthouse_/features/admin_managment/domain/entity/new_admin_entity.dart';

class NewAdminModel extends NewAdminEntity {

  NewAdminModel({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.password,
    required super.role,
  });

  NewAdminModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? role,
  }) {
    return NewAdminModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory NewAdminModel.fromMap(Map<String, dynamic> map) {
    return NewAdminModel(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewAdminModel.fromJson(String source) => NewAdminModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewAdminModel(firstName: $firstName, lastName: $lastName, email: $email, password: $password, role: $role)';
  }

  @override
  bool operator ==(covariant NewAdminModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.password == password &&
      other.role == role;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      password.hashCode ^
      role.hashCode;
  }
}
