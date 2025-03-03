// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
    final String name;
    final double costPrice;
    final int quantity;
    final double consumptionPrice;
    final String barCode;
  ProductModel({
    required this.name,
    required this.costPrice,
    required this.quantity,
    required this.consumptionPrice,
    required this.barCode,
  });

  ProductModel copyWith({
    String? name,
    double? costPrice,
    int? quantity,
    double? consumptionPrice,
    String? barCode,
  }) {
    return ProductModel(
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      consumptionPrice: consumptionPrice ?? this.consumptionPrice,
      barCode: barCode ?? this.barCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'costPrice': costPrice,
      'quantity': quantity,
      'consumptionPrice': consumptionPrice,
      'barCode': barCode,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] as String,
      costPrice: map['costPrice'] as double,
      quantity: map['quantity'] as int,
      consumptionPrice: map['consumptionPrice'] as double,
      barCode: map['barCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(name: $name, costPrice: $costPrice, quantity: $quantity, consumptionPrice: $consumptionPrice, barCode: $barCode)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.costPrice == costPrice &&
      other.quantity == quantity &&
      other.consumptionPrice == consumptionPrice &&
      other.barCode == barCode;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      costPrice.hashCode ^
      quantity.hashCode ^
      consumptionPrice.hashCode ^
      barCode.hashCode;
  }
}
