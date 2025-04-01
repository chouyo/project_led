import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:project_led/translations/locales.dart';
import '../../../infrastructure/data/theme_model.dart';
import '../../../infrastructure/data/locale_model.dart';

class OptionController extends GetxController {
  final Rx<ThemeMode> selectedThemeMode = ThemeMode.system.obs;
  final Rx<Locale> selectedLocale = Get.deviceLocale?.obs as Rx<Locale>;

  late Box<ThemeModel> themeModelBox;
  late Box<LocaleModel> localeModelBox;

  @override
  void onInit() async {
    super.onInit();

    // 初始化主题
    loadTheme();
    // 初始化语言
    loadLocale();
  }

  Future<void> loadTheme() async {
    themeModelBox = await Hive.openBox<ThemeModel>('themeModel');
    var themeModel = themeModelBox.get('themeModel');
    if (themeModel == null) {
      selectedThemeMode.value = ThemeMode.system;
    } else {
      selectedThemeMode.value = themeModel.themeMode;
    }
  }

  Future<void> loadLocale() async {
    localeModelBox = await Hive.openBox<LocaleModel>('localeModel');
    var localeModel = localeModelBox.get('localeModel');
    if (localeModel == null) {
      if (Get.deviceLocale?.scriptCode != null &&
          Get.deviceLocale!.scriptCode!.isNotEmpty) {
        selectedLocale.value = Locale(
            Get.deviceLocale!.languageCode, Get.deviceLocale!.scriptCode!);
      } else {
        selectedLocale.value = Locale(Get.deviceLocale!.languageCode);
      }
      if (!locales.keys.contains(selectedLocale.value.toString())) {
        selectedLocale.value = getFallbackLocale();
      }
    } else {
      selectedLocale.value = parseLocaleByModel(localeModel);
    }

    print(Get.deviceLocale);
    print(selectedLocale.value);
  }

  void setTheme(ThemeMode themeMode) {
    selectedThemeMode.value = themeMode;
    _updateTheme(themeMode);
  }

  void _updateTheme(ThemeMode themeMode) {
    themeModelBox.put('themeModel', ThemeModel(themeMode: themeMode));
  }

  Locale parseLocaleByString(String locale) {
    var localeParts = locale.split('_');
    if (localeParts.length == 2) {
      return Locale(localeParts[0], localeParts[1]);
    } else {
      return Locale(localeParts[0]);
    }
  }

  Locale parseLocaleByModel(LocaleModel localeModel) {
    if (localeModel.countryCode.isNotEmpty) {
      return Locale(localeModel.languageCode, localeModel.countryCode);
    } else {
      return Locale(localeModel.languageCode);
    }
  }

  void setLocale(Locale locale) {
    selectedLocale.value = locale;
    _updateLocale(locale);
    Get.updateLocale(locale);
  }

  void _updateLocale(Locale locale) {
    localeModelBox.put(
        'localeModel',
        LocaleModel(
          languageCode: locale.languageCode,
          scriptCode: locale.scriptCode ?? '',
          countryCode: locale.countryCode ?? '',
        ));
  }

  String getLocaleString(Locale locale) {
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}'.tr;
    } else {
      return locale.languageCode.tr;
    }
  }

  Locale getFallbackLocale() {
    return Locale('en');
  }
}
