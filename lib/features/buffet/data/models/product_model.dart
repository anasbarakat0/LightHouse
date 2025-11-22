// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  final String name;
  final double costPrice;
  final int quantity;
  final double consumptionPrice;
  final String barCode;
  final String shortCut;
  ProductModel({
    required this.name,
    required this.costPrice,
    required this.quantity,
    required this.consumptionPrice,
    required this.barCode,
    required this.shortCut,
  });

  ProductModel copyWith({
    String? name,
    double? costPrice,
    int? quantity,
    double? consumptionPrice,
    String? barCode,
    String? shortCut,
  }) {
    return ProductModel(
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      consumptionPrice: consumptionPrice ?? this.consumptionPrice,
      barCode: barCode ?? this.barCode,
      shortCut: shortCut ?? this.shortCut,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'costPrice': costPrice,
      'quantity': quantity,
      'consumptionPrice': consumptionPrice,
      'barCode': barCode,
      'shortCut': shortCut,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: (map['name'] ?? '').toString(),
      costPrice: (map['costPrice'] as num? ?? 0).toDouble(),
      quantity: (map['quantity'] as num? ?? 0).toInt(),
      consumptionPrice: (map['consumptionPrice'] as num? ?? 0).toDouble(),
      barCode: (map['barCode'] ?? '').toString(),
      shortCut: (map['shortCut']  ?? "").toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(name: $name, costPrice: $costPrice, quantity: $quantity, consumptionPrice: $consumptionPrice, barCode: $barCode, shortCut: $shortCut)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.costPrice == costPrice &&
        other.quantity == quantity &&
        other.consumptionPrice == consumptionPrice &&
        other.barCode == barCode &&
        other.shortCut == shortCut;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        costPrice.hashCode ^
        quantity.hashCode ^
        consumptionPrice.hashCode ^
        barCode.hashCode ^
        shortCut.hashCode;
  }
}
