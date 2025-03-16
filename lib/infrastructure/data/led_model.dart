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
    required this.backgroundColor, // Default color
    required this.speed, // Default speed
    required this.textColor, // Default text color
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
        'type': type,
        'lastUsed': lastUsed,
        'backgroundColor': backgroundColor,
        'speed': speed.toDouble(),
        'textColor': textColor,
      };

  factory Led.fromJson(Map<String, dynamic> json) => Led(
        name: json['name'],
        status: json['status'],
        type: json['type'],
        lastUsed: json['lastUsed'],
        backgroundColor: json['backgroundColor'],
        speed: json['speed'],
        textColor: json['textColor'],
      );
}
