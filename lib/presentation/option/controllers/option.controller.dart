import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/data/language_model.dart';
import '../../../infrastructure/data/theme_model.dart';

class OptionController extends GetxController {
  //TODO: Implement OptionController

  final count = 0.obs;
  final Rx<Language?> selectedLanguage = Rx<Language?>(null);
  final Rx<ThemeModel?> selectedTheme = Rx<ThemeModel?>(null);

  void increment() => count.value++;

  void setLanguage(Language language) {
    selectedLanguage.value = language;
    // Here you can add logic to persist the selection
    // and update the app's locale
    Get.updateLocale(Locale(language.code));
  }

  void setTheme(ThemeModel theme) {
    selectedTheme.value = theme;
    // Add theme change logic here
  }
}
