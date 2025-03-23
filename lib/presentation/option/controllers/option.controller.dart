import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../infrastructure/data/language_model.dart';
import '../../../infrastructure/data/theme_model.dart';

class OptionController extends GetxController {
  final selectedThemeMode = ThemeMode.system.obs;
  final Rx<Language?> selectedLanguage = Rx<Language?>(null);

  late Box<ThemeModel> box;

  @override
  void onInit() async {
    super.onInit();
    box = await Hive.openBox<ThemeModel>('themeModel');

    var theme = box.get('themeModel');
    if (theme == null) {
      setTheme(selectedThemeMode.value);
      theme = box.get('themeModel');
    }
    selectedThemeMode.value = theme!.themeMode;
  }

  void setLanguage(Language language) {
    selectedLanguage.value = language;
    print(language);
    Get.updateLocale(Locale(language.code));
  }

  void setTheme(ThemeMode themeMode) {
    selectedThemeMode.value = themeMode;
    print(themeMode);
    _updateTheme(themeMode);
  }

  void _updateTheme(ThemeMode themeMode) {
    box.put('themeModel', ThemeModel(themeMode: themeMode));
  }
}
