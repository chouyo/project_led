import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'theme_model.g.dart';

@HiveType(typeId: 2)
class ThemeModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final bool isDark;

  @HiveField(2)
  final Color primaryColor;

  const ThemeModel({
    required this.name,
    required this.isDark,
    required this.primaryColor,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'isDark': isDark,
        'primaryColor': primaryColor.value,
      };

  factory ThemeModel.fromJson(Map<String, dynamic> json) => ThemeModel(
        name: json['name'],
        isDark: json['isDark'],
        primaryColor: Color(json['primaryColor']),
      );
}
