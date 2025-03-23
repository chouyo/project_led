import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'theme_model.g.dart';

@HiveType(typeId: 2)
class ThemeModel {
  @HiveField(0)
  final ThemeMode themeMode;

  const ThemeModel({
    required this.themeMode,
  });

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode,
      };

  factory ThemeModel.fromJson(Map<String, dynamic> json) => ThemeModel(
        themeMode: json['themeMode'],
      );
}
