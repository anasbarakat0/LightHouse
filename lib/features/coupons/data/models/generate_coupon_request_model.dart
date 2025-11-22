// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:lighthouse/features/coupons/data/models/coupon_model.dart';

class GenerateCouponRequestModel {
  final CodeMode codeMode;
  final int? count;
  final String? code;
  final DiscountType discountType;
  final double discountValue;
  final int maxUsesPerCode;
  final int? maxUsesPerUser;
  final double? minBaseAmount;
  final String? validFrom;
  final String? validTo;
  final AppliesTo appliesTo;
  final String? prefix;
  final String? notes;

  GenerateCouponRequestModel({
    required this.codeMode,
    this.count,
    this.code,
    required this.discountType,
    required this.discountValue,
    required this.maxUsesPerCode,
    this.maxUsesPerUser,
    this.minBaseAmount,
    this.validFrom,
    this.validTo,
    required this.appliesTo,
    this.prefix,
    this.notes,
  });

  GenerateCouponRequestModel copyWith({
    CodeMode? codeMode,
    int? count,
    String? code,
    DiscountType? discountType,
    double? discountValue,
    int? maxUsesPerCode,
    int? maxUsesPerUser,
    double? minBaseAmount,
    String? validFrom,
    String? validTo,
    AppliesTo? appliesTo,
    String? prefix,
    String? notes,
  }) {
    return GenerateCouponRequestModel(
      codeMode: codeMode ?? this.codeMode,
      count: count ?? this.count,
      code: code ?? this.code,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      maxUsesPerCode: maxUsesPerCode ?? this.maxUsesPerCode,
      maxUsesPerUser: maxUsesPerUser ?? this.maxUsesPerUser,
      minBaseAmount: minBaseAmount ?? this.minBaseAmount,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      appliesTo: appliesTo ?? this.appliesTo,
      prefix: prefix ?? this.prefix,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codeMode': codeMode.name,
      if (count != null) 'count': count,
      if (code != null) 'code': code,
      'discountType': discountType.name,
      'discountValue': discountValue,
      'maxUsesPerCode': maxUsesPerCode,
      if (maxUsesPerUser != null) 'maxUsesPerUser': maxUsesPerUser,
      if (minBaseAmount != null) 'minBaseAmount': minBaseAmount,
      if (validFrom != null) 'validFrom': validFrom,
      if (validTo != null) 'validTo': validTo,
      'appliesTo': appliesTo.name,
      if (prefix != null && prefix!.isNotEmpty) 'prefix': prefix,
      if (notes != null) 'notes': notes,
    };
  }

  factory GenerateCouponRequestModel.fromMap(Map<String, dynamic> map) {
    return GenerateCouponRequestModel(
      codeMode: CodeMode.values.firstWhere(
        (e) => e.name == map['codeMode'],
        orElse: () => CodeMode.MANUAL,
      ),
      count: map['count'] as int?,
      code: map['code'] as String?,
      discountType: DiscountType.values.firstWhere(
        (e) => e.name == map['discountType'],
        orElse: () => DiscountType.AMOUNT,
      ),
      discountValue: (map['discountValue'] as num).toDouble(),
      maxUsesPerCode: map['maxUsesPerCode'] as int,
      maxUsesPerUser: map['maxUsesPerUser'] as int?,
      minBaseAmount: map['minBaseAmount'] != null
          ? (map['minBaseAmount'] as num).toDouble()
          : null,
      validFrom: map['validFrom'] as String?,
      validTo: map['validTo'] as String?,
      appliesTo: AppliesTo.values.firstWhere(
        (e) => e.name == map['appliesTo'],
        orElse: () => AppliesTo.TOTAL_INVOICE,
      ),
      prefix: map['prefix'] as String?,
      notes: map['notes'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenerateCouponRequestModel.fromJson(String source) =>
      GenerateCouponRequestModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GenerateCouponRequestModel(codeMode: $codeMode, count: $count, code: $code, discountType: $discountType, discountValue: $discountValue, maxUsesPerCode: $maxUsesPerCode, maxUsesPerUser: $maxUsesPerUser, minBaseAmount: $minBaseAmount, validFrom: $validFrom, validTo: $validTo, appliesTo: $appliesTo, prefix: $prefix, notes: $notes)';
  }

  @override
  bool operator ==(covariant GenerateCouponRequestModel other) {
    if (identical(this, other)) return true;

    return other.codeMode == codeMode &&
        other.count == count &&
        other.code == code &&
        other.discountType == discountType &&
        other.discountValue == discountValue &&
        other.maxUsesPerCode == maxUsesPerCode &&
        other.maxUsesPerUser == maxUsesPerUser &&
        other.minBaseAmount == minBaseAmount &&
        other.validFrom == validFrom &&
        other.validTo == validTo &&
        other.appliesTo == appliesTo &&
        other.prefix == prefix &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return codeMode.hashCode ^
        count.hashCode ^
        code.hashCode ^
        discountType.hashCode ^
        discountValue.hashCode ^
        maxUsesPerCode.hashCode ^
        maxUsesPerUser.hashCode ^
        minBaseAmount.hashCode ^
        validFrom.hashCode ^
        validTo.hashCode ^
        appliesTo.hashCode ^
        prefix.hashCode ^
        notes.hashCode;
  }
}

