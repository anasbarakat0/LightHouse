// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum DebtTransactionType {
  debt,
  payment,
}

extension DebtTransactionTypeMapper on DebtTransactionType {
  String get value {
    switch (this) {
      case DebtTransactionType.debt:
        return 'debt';
      case DebtTransactionType.payment:
        return 'payment';
    }
  }

  static DebtTransactionType fromValue(String? value) {
    if (value == DebtTransactionType.payment.value) {
      return DebtTransactionType.payment;
    }
    return DebtTransactionType.debt;
  }
}

class DebtTransaction {
  final String id;
  final String accountId;
  final DebtTransactionType type;
  final double amount;
  final String note;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? syncedAt;

  const DebtTransaction({
    required this.id,
    required this.accountId,
    required this.type,
    required this.amount,
    required this.createdAt,
    required this.createdBy,
    this.note = '',
    this.syncedAt,
  });

  double get signedAmount {
    if (type == DebtTransactionType.payment) {
      return -amount;
    }
    return amount;
  }

  DebtTransaction copyWith({
    String? id,
    String? accountId,
    DebtTransactionType? type,
    double? amount,
    String? note,
    DateTime? createdAt,
    String? createdBy,
    DateTime? syncedAt,
  }) {
    return DebtTransaction(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'accountId': accountId,
      'type': type.value,
      'amount': amount,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }

  factory DebtTransaction.fromMap(Map<String, dynamic> map) {
    final amountValue = map['amount'];

    return DebtTransaction(
      id: (map['id'] ?? '').toString(),
      accountId: (map['accountId'] ?? '').toString(),
      type: DebtTransactionTypeMapper.fromValue(
        (map['type'] ?? '').toString(),
      ),
      amount: amountValue is num
          ? amountValue.toDouble()
          : double.tryParse(amountValue.toString()) ?? 0,
      note: (map['note'] ?? '').toString(),
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      createdBy: (map['createdBy'] ?? '').toString(),
      syncedAt: DateTime.tryParse((map['syncedAt'] ?? '').toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory DebtTransaction.fromJson(String source) {
    return DebtTransaction.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
