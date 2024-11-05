import 'package:lighthouse_/features/login/domain/entity/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    super.email,
    super.password,
  });

  LoginModel copyWith({
    String? email,
    String? password,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => toMap();

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      LoginModel.fromMap(json);
}
