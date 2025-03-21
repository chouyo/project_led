import 'package:uuid/uuid.dart';

import 'constants.dart';
import 'led_model.dart';

class MockLeds {
  static List<Led> leds = [
    Led(
      id: Uuid().v4(),
      name: 'Hello',
      description: '',
      lastUsed: DateTime.now().toIso8601String(),
      speed: ESpeed.normal,
      textColorIndex: getRandomTextColorIndex(),
      backgroundColorIndex: getRandomBackgroundColorIndex(),
    ),
    Led(
      id: Uuid().v4(),
      name: 'Thank you',
      description: '',
      lastUsed: DateTime.now().toIso8601String(),
      speed: ESpeed.normal,
      textColorIndex: getRandomTextColorIndex(),
      backgroundColorIndex: getRandomBackgroundColorIndex(),
    ),
    Led(
      id: Uuid().v4(),
      name: 'Goodbye',
      description: '',
      lastUsed: DateTime.now().toIso8601String(),
      speed: ESpeed.normal,
      textColorIndex: getRandomTextColorIndex(),
      backgroundColorIndex: getRandomBackgroundColorIndex(),
    ),
    Led(
      id: Uuid().v4(),
      name: 'I love you',
      description: '',
      lastUsed: DateTime.now().toIso8601String(),
      speed: ESpeed.normal,
      textColorIndex: getRandomTextColorIndex(),
      backgroundColorIndex: getRandomBackgroundColorIndex(),
    ),
    Led(
      id: Uuid().v4(),
      name: 'I miss you',
      description: '',
      lastUsed: DateTime.now().toIso8601String(),
      speed: ESpeed.normal,
      textColorIndex: getRandomTextColorIndex(),
      backgroundColorIndex: getRandomBackgroundColorIndex(),
    ),
  ];
}
