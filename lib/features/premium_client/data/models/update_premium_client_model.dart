// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdatePremiumClientModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String study;
  final String birthDate;

  UpdatePremiumClientModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.study,
    required this.birthDate,
  });

  UpdatePremiumClientModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? study,
    String? birthDate,
  }) {
    return UpdatePremiumClientModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      study: study ?? this.study,
      birthDate: birthDate ?? this.birthDate,
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
    };
  }

  factory UpdatePremiumClientModel.fromMap(Map<String, dynamic> map) {
    return UpdatePremiumClientModel(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      gender: map['gender'] as String,
      study: map['study'] as String,
      birthDate: map['birthDate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdatePremiumClientModel.fromJson(String source) =>
      UpdatePremiumClientModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UpdatePremiumClientModel(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, gender: $gender, study: $study, birthDate: $birthDate)';
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
        other.birthDate == birthDate;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        gender.hashCode ^
        study.hashCode ^
        birthDate.hashCode;
  }
}

