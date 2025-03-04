import 'package:flutter/material.dart';
import 'theme_model.dart';

class MockThemes {
  static const List<ThemeModel> themes = [
    ThemeModel(
      name: 'Light Blue',
      isDark: false,
      primaryColor: Colors.blue,
    ),
    ThemeModel(
      name: 'Dark Blue',
      isDark: true,
      primaryColor: Colors.blue,
    ),
    ThemeModel(
      name: 'Light Purple',
      isDark: false,
      primaryColor: Colors.purple,
    ),
    ThemeModel(
      name: 'Dark Purple',
      isDark: true,
      primaryColor: Colors.purple,
    ),
  ];
}
