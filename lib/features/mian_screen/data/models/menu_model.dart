// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class MenuModel {
  final IconData icon;
  final String title;
  MenuModel({
    required this.icon,
    required this.title,
  });

  MenuModel copyWith({
    IconData? icon,
    String? title,
  }) {
    return MenuModel(
      icon: icon ?? this.icon,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'icon': icon.codePoint,
      'title': title,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) =>
      MenuModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MenuModel(icon: $icon, title: $title)';

  @override
  bool operator ==(covariant MenuModel other) {
    if (identical(this, other)) return true;

    return other.icon == icon && other.title == title;
  }

  @override
  int get hashCode => icon.hashCode ^ title.hashCode;
}
