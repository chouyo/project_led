import 'package:hive/hive.dart';

import 'constants.dart';

part 'led_model.g.dart';

@HiveType(typeId: 0)
class Led {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String lastUsed;

  @HiveField(4)
  final ESpeed speed;

  @HiveField(5)
  final int textColorIndex;

  @HiveField(6)
  final int backgroundColorIndex;

  Led({
    required this.id,
    required this.name,
    required this.description,
    required this.lastUsed,
    required this.speed,
    required this.textColorIndex,
    required this.backgroundColorIndex,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'lastUsed': lastUsed,
        'speed': speed,
        'textColorIndex': textColorIndex,
        'backgroundColorIndex': backgroundColorIndex,
      };

  factory Led.fromJson(Map<String, dynamic> json) => Led(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        lastUsed: json['lastUsed'],
        speed: json['speed'],
        textColorIndex: json['textColorIndex'],
        backgroundColorIndex: json['backgroundColorIndex'],
      );
}
