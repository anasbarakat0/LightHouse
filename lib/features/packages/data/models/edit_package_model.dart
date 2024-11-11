// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PackageModel {
    final int numOfHours;
    final double price;
    final String description;
    final int packageDurationInDays;
    final bool active;
  PackageModel({
    required this.numOfHours,
    required this.price,
    required this.description,
    required this.packageDurationInDays,
    required this.active,
  });

  PackageModel copyWith({
    int? numOfHours,
    double? price,
    String? description,
    int? packageDurationInDays,
    bool? active,
  }) {
    return PackageModel(
      numOfHours: numOfHours ?? this.numOfHours,
      price: price ?? this.price,
      description: description ?? this.description,
      packageDurationInDays: packageDurationInDays ?? this.packageDurationInDays,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'numOfHours': numOfHours,
      'price': price,
      'description': description,
      'packageDurationInDays': packageDurationInDays,
      'active': active,
    };
  }

  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
      numOfHours: map['numOfHours'] as int,
      price: map['price'] as double,
      description: map['description'] as String,
      packageDurationInDays: map['packageDurationInDays'] as int,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PackageModel.fromJson(String source) => PackageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PackageModel(numOfHours: $numOfHours, price: $price, description: $description, packageDurationInDays: $packageDurationInDays, active: $active)';
  }

  @override
  bool operator ==(covariant PackageModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.numOfHours == numOfHours &&
      other.price == price &&
      other.description == description &&
      other.packageDurationInDays == packageDurationInDays &&
      other.active == active;
  }

  @override
  int get hashCode {
    return numOfHours.hashCode ^
      price.hashCode ^
      description.hashCode ^
      packageDurationInDays.hashCode ^
      active.hashCode;
  }
}
