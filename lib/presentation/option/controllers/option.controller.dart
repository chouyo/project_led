import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../translations/locales.dart';
import '../../../infrastructure/data/theme_model.dart';
import '../../../infrastructure/data/locale_model.dart';
import '../../list/controllers/list.controller.dart';

class OptionController extends GetxController {
  final Rx<ThemeMode> selectedThemeMode = ThemeMode.system.obs;
  final Rx<Locale> selectedLocale = Get.deviceLocale?.obs as Rx<Locale>;

  late Box<ThemeModel> themeModelBox;
  late Box<LocaleModel> localeModelBox;

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
        if (['Hans', 'Hant'].contains(Get.deviceLocale!.scriptCode)) {
          selectedLocale.value = Locale('zh', Get.deviceLocale!.scriptCode!);
        } else {
          selectedLocale.value = Locale(Get.deviceLocale!.languageCode);
        }
      } else {
        if (['zh_CN'].contains(Get.deviceLocale!.toString())) {
          selectedLocale.value = Locale('zh', 'Hans');
        } else if (['zh_TW', 'zh_HK', 'zh_MO', 'zh_SG']
            .contains(Get.deviceLocale!.toString())) {
          selectedLocale.value = Locale('zh', 'Hant');
        } else {
          selectedLocale.value = Locale(Get.deviceLocale!.languageCode);
        }
      }
      if (!locales.keys.contains(selectedLocale.value.toString())) {
        selectedLocale.value = getFallbackLocale();
      }
    } else {
      selectedLocale.value = parseLocaleByModel(localeModel);
    }
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

  void loadDefaultData() {
    final listController = Get.put(ListController());
    listController.loadDefaultData();
  }
}
