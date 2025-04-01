import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../infrastructure/data/constants.dart';
import '../../../infrastructure/data/led_model.dart';
import '../../list/controllers/list.controller.dart';

import 'dart:ui' as ui;

class HomeController extends GetxController {
  final showOverlay = false.obs;
  final speed = ESpeed.normal.obs;
  final backgroundColorIndex = 0.obs;
  final textColorIndex = 0.obs;
  final isLandscape = false.obs;
  late Box<Led> box;
  late Led currentLed;

  void toggleOverlay() => showOverlay.toggle();

  void updateSpeed(double value) {
    speed.value = ESpeed.values[value.toInt()];
    _updateLed();
  }

  void updateBackgroundColorIndex(int index) {
    backgroundColorIndex.value = index;
    _updateLed();
  }

  void updateTextColorIndex(int index) {
    textColorIndex.value = index;
    _updateLed();
  }

  void toggleOrientation() {
    Vibration.vibrate(duration: 50);
    toggleOverlay();
    isLandscape.value = !isLandscape.value;
    if (isLandscape.value) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  void goBack() {
    Vibration.vibrate(duration: 50);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Get.back();
  }

  void _updateLed() {
    final updatedLed = Led(
      id: currentLed.id,
      name: currentLed.name,
      description: currentLed.description,
      lastUsed: currentLed.lastUsed,
      speed: speed.value, // Convert ESpeed to in
      textColorIndex: textColorIndex.value,
      backgroundColorIndex: backgroundColorIndex.value,
    );

    final index =
        box.values.toList().indexWhere((led) => led.id == currentLed.id);

    if (index != -1) {
      box.putAt(index, updatedLed);
      currentLed = updatedLed;
      Get.find<ListController>().updateLed(index, updatedLed);
    }
  }

  @override
  void onInit() async {
    super.onInit();

    WakelockPlus.enable();

    box = await Hive.openBox<Led>('leds');

    // Get current LED data
    final led = Led.fromJson(Get.arguments);
    currentLed = led;
    speed.value = led.speed; // Initialize with stored speed
    backgroundColorIndex.value = led.backgroundColorIndex;
    textColorIndex.value = led.textColorIndex;

    toggleOverlay();

    printSystemLocales();
    final locale = ui.window.locales.first;
    print('Locale: ${locale.languageCode}, Country: ${locale.countryCode}');
  }

  @override
  void onClose() {
    WakelockPlus.disable();

    super.onClose();
  }

  String getSpeedLabel(int value) {
    switch (ESpeed.values[value]) {
      case ESpeed.fast:
        return 'fast';
      case ESpeed.normal:
        return 'normal';
      case ESpeed.slow:
        return 'slow';
    }
  }

  double calculateOverlayWidth(BuildContext context) {
    return isLandscape.value
        ? MediaQuery.of(context).size.width * 0.5
        : MediaQuery.of(context).size.width * 0.95;
  }
}

List<Locale> getSystemLocales() {
  return ui.window.locales;
}

void printSystemLocales() {
  final locales = getSystemLocales();
  for (var locale in locales) {
    print('Language: ${locale.languageCode}, Country: ${locale.countryCode}');
  }
}
