// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdatePremiumClientModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? study;
  final String? birthDate;
  final String? password;

  UpdatePremiumClientModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.study,
    this.birthDate,
    this.password,
  });

  UpdatePremiumClientModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? study,
    String? birthDate,
    String? password,
  }) {
    return UpdatePremiumClientModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      study: study ?? this.study,
      birthDate: birthDate ?? this.birthDate,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'study': study,
      'birthDate': birthDate,
      'password': password,
    }..removeWhere((key, value) => value == null);
  }

  factory UpdatePremiumClientModel.fromMap(Map<String, dynamic> map) {
    return UpdatePremiumClientModel(
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      email: map['email'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      gender: map['gender'] as String?,
      study: map['study'] as String?,
      birthDate: map['birthDate'] as String?,
      password: map['password'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdatePremiumClientModel.fromJson(String source) =>
      UpdatePremiumClientModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UpdatePremiumClientModel(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, gender: $gender, study: $study, birthDate: $birthDate, password: $password)';
  }

  @override
  bool operator ==(covariant UpdatePremiumClientModel other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender &&
        other.study == study &&
        other.birthDate == birthDate &&
        other.password == password;
  }

  @override
  int get hashCode {
    return (firstName?.hashCode ?? 0) ^
        (lastName?.hashCode ?? 0) ^
        (email?.hashCode ?? 0) ^
        (phoneNumber?.hashCode ?? 0) ^
        (gender?.hashCode ?? 0) ^
        (study?.hashCode ?? 0) ^
        (birthDate?.hashCode ?? 0) ^
        (password?.hashCode ?? 0);
  }
}
