// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerBirthdayRemindersResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final List<CustomerBirthdayReminder> body;

  CustomerBirthdayRemindersResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory CustomerBirthdayRemindersResponseModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return CustomerBirthdayRemindersResponseModel(
      message: map['message'] as String? ?? '',
      status: map['status'] as String? ?? '',
      localDateTime: map['localDateTime'] as String? ?? '',
      body: (map['body'] as List<dynamic>?)
              ?.map(
                (item) => CustomerBirthdayReminder.fromMap(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status': status,
      'localDateTime': localDateTime,
      'body': body.map((item) => item.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory CustomerBirthdayRemindersResponseModel.fromJson(String source) =>
      CustomerBirthdayRemindersResponseModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

class CustomerBirthdayReminder {
  final String uuid;
  final String fullName;
  final String phoneNumber;
  final String birthDate;
  final String nextBirthday;
  final int daysUntilBirthday;

  CustomerBirthdayReminder({
    required this.uuid,
    required this.fullName,
    required this.phoneNumber,
    required this.birthDate,
    required this.nextBirthday,
    required this.daysUntilBirthday,
  });

  factory CustomerBirthdayReminder.fromMap(Map<String, dynamic> map) {
    return CustomerBirthdayReminder(
      uuid: map['uuid'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      birthDate: map['birthDate'] as String? ?? '',
      nextBirthday: map['nextBirthday'] as String? ?? '',
      daysUntilBirthday: map['daysUntilBirthday'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'nextBirthday': nextBirthday,
      'daysUntilBirthday': daysUntilBirthday,
    };
  }
}
