import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

import '../../../infrastructure/data/led_model.dart';
import '../../list/controllers/list.controller.dart';

class HomeController extends GetxController {
  final showOverlay = false.obs;
  final speed = 1.0.obs;
  final textColor = Colors.white.obs;
  final backgroundColor = Colors.white.obs;
  final box = Hive.box<Led>('leds');
  late Led currentLed;

  void toggleOverlay() => showOverlay.toggle();

  void updateTextColor(Color color) {
    textColor.value = color;
    _updateLed();
  }

  void updateSpeed(double value) {
    speed.value = value.toDouble();
    _updateLed();
  }

  void updateBackgroundColor(Color color) {
    backgroundColor.value = color;
    _updateLed();
  }

  void _updateLed() {
    final updatedLed = Led(
      name: currentLed.name,
      status: currentLed.status,
      type: currentLed.type,
      lastUsed: currentLed.lastUsed,
      backgroundColor: backgroundColor.value,
      speed: speed.value,
      textColor: textColor.value,
    );

    final index = box.values.toList().indexWhere(
        (led) => led.name == currentLed.name && led.type == currentLed.type);

    if (index != -1) {
      box.putAt(index, updatedLed);
      currentLed = updatedLed;
      Get.find<ListController>().updateLed(index, updatedLed);
    }
  }

  @override
  void onInit() async {
    super.onInit();

    // Get current LED data
    final led = Led.fromJson(Get.arguments);
    currentLed = led;
    speed.value = led.speed; // Initialize with stored speed
    textColor.value = led.textColor;
    backgroundColor.value = led.backgroundColor; // Initialize background color

    // Hide system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Force landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void onClose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.onClose();
  }

  String getSpeedLabel(double value) {
    if (value <= 1.0) return 'Fast';
    if (value <= 5.5) return 'Normal';
    return 'Slow';
  }

  HSVColor getColorFromSlider(double value) {
    double hue, saturation, valueColor;

    if (value < 0.33) {
      // 从黑色到彩色：调整亮度
      hue = 0; // 固定色相
      saturation = 1; // 固定饱和度
      valueColor = value / 0.33; // 亮度从 0 到 1
    } else if (value < 0.66) {
      // 从彩色到白色：调整饱和度
      hue = (value - 0.33) / 0.33 * 360; // 色相从 0 到 360
      saturation = 1 - (value - 0.33) / 0.33; // 饱和度从 1 到 0
      valueColor = 1; // 固定亮度
    } else {
      // 从白色回到彩色：调整色相
      hue = (value - 0.66) / 0.34 * 360; // 色相从 0 到 360
      saturation = 1; // 固定饱和度
      valueColor = 1; // 固定亮度
    }

    return HSVColor.fromAHSV(1.0, hue, saturation, valueColor);
  }
}
