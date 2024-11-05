// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PremiumClient {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String gender;
  final String study;
  final String birthDate;
  PremiumClient({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.gender,
    required this.study,
    required this.birthDate,
  });

  PremiumClient copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phoneNumber,
    String? gender,
    String? study,
    String? birthDate,
  }) {
    return PremiumClient(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
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
      'password': password,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'study': study,
      'birthDate': birthDate,
    };
  }

  factory PremiumClient.fromMap(Map<String, dynamic> map) {
    return PremiumClient(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phoneNumber: map['phoneNumber'] as String,
      gender: map['gender'] as String,
      study: map['study'] as String,
      birthDate: map['birthDate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PremiumClient.fromJson(String source) => PremiumClient.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PremiumClient(firstName: $firstName, lastName: $lastName, email: $email, password: $password, phoneNumber: $phoneNumber, gender: $gender, study: $study, birthDate: $birthDate)';
  }

  @override
  bool operator ==(covariant PremiumClient other) {
    if (identical(this, other)) return true;
  
    return 
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.password == password &&
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
      password.hashCode ^
      phoneNumber.hashCode ^
      gender.hashCode ^
      study.hashCode ^
      birthDate.hashCode;
  }
}
