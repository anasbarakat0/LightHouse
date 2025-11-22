// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum CodeMode {
  RANDOM,
  MANUAL,
}

enum DiscountType {
  AMOUNT,
  PERCENT,
}

enum AppliesTo {
  SESSION_INVOICE,
  BUFFET_INVOICE,
  TOTAL_INVOICE,
}

class CouponModel {
  final String id;
  final String code;
  final DiscountType discountType;
  final double discountValue;
  final AppliesTo appliesTo;
  final int maxUsesPerCode;
  final int usedCount;
  final int remainingUses;
  final int? maxUsesPerUser;
  final double? minBaseAmount;
  final String? validFrom;
  final String? validTo;
  final bool active;
  final String? notes;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final int? distinctUsersCount;

  CouponModel({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.appliesTo,
    required this.maxUsesPerCode,
    required this.usedCount,
    required this.remainingUses,
    this.maxUsesPerUser,
    this.minBaseAmount,
    this.validFrom,
    this.validTo,
    required this.active,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.distinctUsersCount,
  });

  CouponModel copyWith({
    String? id,
    String? code,
    DiscountType? discountType,
    double? discountValue,
    AppliesTo? appliesTo,
    int? maxUsesPerCode,
    int? usedCount,
    int? remainingUses,
    int? maxUsesPerUser,
    double? minBaseAmount,
    String? validFrom,
    String? validTo,
    bool? active,
    String? notes,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    int? distinctUsersCount,
  }) {
    return CouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      appliesTo: appliesTo ?? this.appliesTo,
      maxUsesPerCode: maxUsesPerCode ?? this.maxUsesPerCode,
      usedCount: usedCount ?? this.usedCount,
      remainingUses: remainingUses ?? this.remainingUses,
      maxUsesPerUser: maxUsesPerUser ?? this.maxUsesPerUser,
      minBaseAmount: minBaseAmount ?? this.minBaseAmount,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      active: active ?? this.active,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      distinctUsersCount: distinctUsersCount ?? this.distinctUsersCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'discountType': discountType.name,
      'discountValue': discountValue,
      'appliesTo': appliesTo.name,
      'maxUsesPerCode': maxUsesPerCode,
      'usedCount': usedCount,
      'remainingUses': remainingUses,
      'maxUsesPerUser': maxUsesPerUser,
      'minBaseAmount': minBaseAmount,
      'validFrom': validFrom,
      'validTo': validTo,
      'active': active,
      'notes': notes,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'distinctUsersCount': distinctUsersCount,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      id: map['id'] as String,
      code: map['code'] as String,
      discountType: DiscountType.values.firstWhere(
        (e) => e.name == map['discountType'],
        orElse: () => DiscountType.AMOUNT,
      ),
      discountValue: (map['discountValue'] as num).toDouble(),
      appliesTo: AppliesTo.values.firstWhere(
        (e) => e.name == map['appliesTo'],
        orElse: () => AppliesTo.TOTAL_INVOICE,
      ),
      maxUsesPerCode: map['maxUsesPerCode'] as int,
      usedCount: map['usedCount'] as int? ?? 0,
      remainingUses: map['remainingUses'] as int? ?? 0,
      maxUsesPerUser: map['maxUsesPerUser'] as int?,
      minBaseAmount: map['minBaseAmount'] != null
          ? (map['minBaseAmount'] as num).toDouble()
          : null,
      validFrom: map['validFrom'] as String?,
      validTo: map['validTo'] as String?,
      active: map['active'] as bool? ?? true,
      notes: map['notes'] as String?,
      createdBy: map['createdBy'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      distinctUsersCount: map['distinctUsersCount'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) =>
      CouponModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CouponModel(id: $id, code: $code, discountType: $discountType, discountValue: $discountValue, appliesTo: $appliesTo, maxUsesPerCode: $maxUsesPerCode, usedCount: $usedCount, remainingUses: $remainingUses, maxUsesPerUser: $maxUsesPerUser, minBaseAmount: $minBaseAmount, validFrom: $validFrom, validTo: $validTo, active: $active, notes: $notes, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, distinctUsersCount: $distinctUsersCount)';
  }

  @override
  bool operator ==(covariant CouponModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.discountType == discountType &&
        other.discountValue == discountValue &&
        other.appliesTo == appliesTo &&
        other.maxUsesPerCode == maxUsesPerCode &&
        other.usedCount == usedCount &&
        other.remainingUses == remainingUses &&
        other.maxUsesPerUser == maxUsesPerUser &&
        other.minBaseAmount == minBaseAmount &&
        other.validFrom == validFrom &&
        other.validTo == validTo &&
        other.active == active &&
        other.notes == notes &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.distinctUsersCount == distinctUsersCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        discountType.hashCode ^
        discountValue.hashCode ^
        appliesTo.hashCode ^
        maxUsesPerCode.hashCode ^
        usedCount.hashCode ^
        remainingUses.hashCode ^
        maxUsesPerUser.hashCode ^
        minBaseAmount.hashCode ^
        validFrom.hashCode ^
        validTo.hashCode ^
        active.hashCode ^
        notes.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        distinctUsersCount.hashCode;
  }
}

