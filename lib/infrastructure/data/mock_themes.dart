import 'package:flutter/material.dart';
import 'theme_model.dart';

class MockThemes {
  static const List<ThemeModel> themes = [
    ThemeModel(
      themeMode: ThemeMode.system,
    ),
    ThemeModel(
      themeMode: ThemeMode.light,
    ),
    ThemeModel(
      themeMode: ThemeMode.dark,
    ),
  ];
}
