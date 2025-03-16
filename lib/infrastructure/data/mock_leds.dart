import 'package:flutter/material.dart';
import 'led_model.dart';

class MockLeds {
  static List<Led> leds = [
    Led(
      name: 'Living Room LED',
      status: 'Connected',
      type: 'RGB Strip',
      lastUsed: '2 hours ago',
      backgroundColor: Colors.blue[400]!,
      speed: 1.0,
      textColor: Colors.white,
    ),
    Led(
      name: 'Bedroom Light',
      status: 'Disconnected',
      type: 'Smart Bulb',
      lastUsed: '1 day ago',
      backgroundColor: Colors.purple[400]!,
      speed: 1.0,
      textColor: Colors.white,
    ),
    Led(
      name: 'Kitchen Strip',
      status: 'Connected',
      type: 'RGB Strip',
      lastUsed: '5 minutes ago',
      backgroundColor: Colors.green[400]!,
      speed: 1.0,
      textColor: Colors.white,
    ),
    Led(
      name: 'Office Light',
      status: 'Connected',
      type: 'Smart Bulb',
      lastUsed: '1 hour ago',
      backgroundColor: Colors.orange[400]!,
      speed: 1.0,
      textColor: Colors.white,
    ),
    Led(
      name: 'Bathroom LED',
      status: 'Disconnected',
      type: 'RGB Strip',
      lastUsed: '3 days ago',
      backgroundColor: Colors.teal[400]!,
      speed: 1.0,
      textColor: Colors.white,
    ),
  ];
}
