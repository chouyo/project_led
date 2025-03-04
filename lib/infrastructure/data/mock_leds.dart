import 'package:flutter/material.dart';
import 'led_model.dart';

class MockLeds {
  static List<Led> leds = [
    Led(
      name: 'Living Room LED',
      status: 'Connected',
      type: 'RGB Strip',
      lastUsed: '2 hours ago',
      backgroundColor: Colors.blue,
    ),
    Led(
      name: 'Bedroom Light',
      status: 'Disconnected',
      type: 'Smart Bulb',
      lastUsed: '1 day ago',
      backgroundColor: Colors.purple,
    ),
    Led(
      name: 'Kitchen Strip',
      status: 'Connected',
      type: 'RGB Strip',
      lastUsed: '5 minutes ago',
      backgroundColor: Colors.green,
    ),
    Led(
      name: 'Office Light',
      status: 'Connected',
      type: 'Smart Bulb',
      lastUsed: '1 hour ago',
      backgroundColor: Colors.orange,
    ),
    Led(
      name: 'Bathroom LED',
      status: 'Disconnected',
      type: 'RGB Strip',
      lastUsed: '3 days ago',
      backgroundColor: Colors.teal,
    ),
  ];
}
