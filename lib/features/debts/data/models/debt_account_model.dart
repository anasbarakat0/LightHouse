// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DebtAccount {
  final String id;
  final String clientId;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? syncedAt;
  final bool archived;

  const DebtAccount({
    required this.id,
    required this.clientId,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.createdBy,
    this.phoneNumber,
    this.syncedAt,
    this.archived = false,
  });

  String get fullName => '$firstName $lastName'.trim();

  DebtAccount copyWith({
    String? id,
    String? clientId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? createdAt,
    String? createdBy,
    DateTime? syncedAt,
    bool? archived,
  }) {
    return DebtAccount(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      syncedAt: syncedAt ?? this.syncedAt,
      archived: archived ?? this.archived,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clientId': clientId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'syncedAt': syncedAt?.toIso8601String(),
      'archived': archived,
    };
  }

  factory DebtAccount.fromMap(Map<String, dynamic> map) {
    final archivedValue = map['archived'];

    return DebtAccount(
      id: (map['id'] ?? '').toString(),
      clientId: (map['clientId'] ?? '').toString(),
      firstName: (map['firstName'] ?? '').toString(),
      lastName: (map['lastName'] ?? '').toString(),
      phoneNumber:
          map['phoneNumber'] == null || map['phoneNumber'].toString().isEmpty
              ? null
              : map['phoneNumber'].toString(),
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      createdBy: (map['createdBy'] ?? '').toString(),
      syncedAt: DateTime.tryParse((map['syncedAt'] ?? '').toString()),
      archived: archivedValue == true ||
          archivedValue.toString().toLowerCase() == 'true',
    );
  }

  String toJson() => json.encode(toMap());

  factory DebtAccount.fromJson(String source) {
    return DebtAccount.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
