import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'led_model.g.dart';

@HiveType(typeId: 0)
class Led {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String status;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String lastUsed;

  @HiveField(4)
  final Color backgroundColor;

  @HiveField(5)
  final double speed;

  @HiveField(6)
  final Color textColor;

  Led({
    required this.name,
    required this.status,
    required this.type,
    required this.lastUsed,
    this.backgroundColor = Colors.blue, // Default color
    this.speed = 1.0, // Default speed
    this.textColor = Colors.white, // Default text color
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
        'type': type,
        'lastUsed': lastUsed,
        'backgroundColor': backgroundColor.value,
        'speed': speed.toDouble(),
        'textColor': textColor.value,
      };

  factory Led.fromJson(Map<String, dynamic> json) => Led(
        name: json['name'],
        status: json['status'],
        type: json['type'],
        lastUsed: json['lastUsed'],
        backgroundColor: Color(json['backgroundColor'] ?? Colors.blue.value),
        speed: (json['speed'] ?? 1.0).toDouble(),
        textColor: Color(json['textColor'] ?? Colors.white.value),
      );
}
