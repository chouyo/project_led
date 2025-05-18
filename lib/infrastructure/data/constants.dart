import 'dart:math';

import 'package:flutter/material.dart';

List<Color> backgroudColors = [
  Color.fromARGB(255, 127, 29, 29),
  Color.fromARGB(255, 124, 45, 18),
  Color.fromARGB(255, 120, 53, 15),
  Color.fromARGB(255, 113, 63, 18),
  Color.fromARGB(255, 54, 83, 20),
  Color.fromARGB(255, 20, 83, 45),
  Color.fromARGB(255, 6, 78, 59),
  Color.fromARGB(255, 19, 78, 74),
  Color.fromARGB(255, 22, 78, 99),
  Color.fromARGB(255, 12, 74, 110),
  Color.fromARGB(255, 30, 58, 138),
  Color.fromARGB(255, 49, 46, 129),
  Color.fromARGB(255, 76, 29, 149),
  Color.fromARGB(255, 88, 28, 135),
  Color.fromARGB(255, 112, 26, 117),
  Color.fromARGB(255, 131, 24, 67),
  Color.fromARGB(255, 136, 19, 55),
  Color.fromARGB(255, 28, 25, 23),
  Color.fromARGB(255, 23, 23, 23),
  Color.fromARGB(255, 24, 24, 27),
  Color.fromARGB(255, 17, 24, 39),
  Color.fromARGB(255, 15, 23, 42),
  Color.fromARGB(255, 0, 0, 0),
];

List<Color> foregroundColors = [
  Color.fromARGB(255, 252, 165, 165),
  Color.fromARGB(255, 253, 186, 116),
  Color.fromARGB(255, 252, 211, 77),
  Color.fromARGB(255, 253, 224, 71),
  Color.fromARGB(255, 190, 242, 100),
  Color.fromARGB(255, 134, 239, 172),
  Color.fromARGB(255, 110, 231, 183),
  Color.fromARGB(255, 94, 234, 212),
  Color.fromARGB(255, 103, 232, 249),
  Color.fromARGB(255, 125, 211, 252),
  Color.fromARGB(255, 147, 197, 253),
  Color.fromARGB(255, 165, 180, 252),
  Color.fromARGB(255, 196, 181, 253),
  Color.fromARGB(255, 216, 180, 254),
  Color.fromARGB(255, 240, 171, 252),
  Color.fromARGB(255, 249, 168, 212),
  Color.fromARGB(255, 253, 164, 175),
  Color.fromARGB(255, 214, 211, 209),
  Color.fromARGB(255, 212, 212, 212),
  Color.fromARGB(255, 212, 212, 216),
  Color.fromARGB(255, 209, 213, 219),
  Color.fromARGB(255, 203, 213, 225),
  Color.fromARGB(255, 255, 255, 255),
];

int getRandomTextColorIndex() {
  return Random().nextInt(foregroundColors.length);
}

int getRandomBackgroundColorIndex() {
  return Random().nextInt(backgroudColors.length);
}

Color getTextColorFromIndex(int index) {
  return foregroundColors[index];
}

Color getBackgroundColorFromIndex(int index) {
  return backgroudColors[index];
}

enum ESpeed {
  slow,
  normal,
  fast,
}

final String notoSansRegular = "NotoSans-Regular";

enum ETheme { auto, light, dark }

String getThemeModeName(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.system:
      return 'systemTheme';
    case ThemeMode.light:
      return 'lightTheme';
    case ThemeMode.dark:
      return 'darkTheme';
  }
}

List<String> lottieAssets = ['assets/lotties/no_data.json'];

String getRandomLottieAsset() {
  return lottieAssets[Random().nextInt(lottieAssets.length)];
}

final String email = 'xyolstudio@gmail.com';
