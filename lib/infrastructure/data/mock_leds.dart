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
      name: 'Thank You',
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
      name: 'I Love You',
      description: '',
      lastUsed: DateTime.now().toIso8601String(),
      speed: ESpeed.normal,
      textColorIndex: getRandomTextColorIndex(),
      backgroundColorIndex: getRandomBackgroundColorIndex(),
    ),
    Led(
      id: Uuid().v4(),
      name: 'I Miss You',
      description: '',
      lastUsed: DateTime.now().toIso8601String(),
      speed: ESpeed.normal,
      textColorIndex: getRandomTextColorIndex(),
      backgroundColorIndex: getRandomBackgroundColorIndex(),
    ),
  ];
}
