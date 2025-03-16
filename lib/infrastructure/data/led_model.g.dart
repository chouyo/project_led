// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'led_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LedAdapter extends TypeAdapter<Led> {
  @override
  final int typeId = 0;

  @override
  Led read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Led(
      name: fields[0] as String,
      status: fields[1] as String,
      type: fields[2] as String,
      lastUsed: fields[3] as String,
      backgroundColor: fields[4] as Color,
      speed: fields[5] as double,
      textColor: fields[6] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, Led obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.lastUsed)
      ..writeByte(4)
      ..write(obj.backgroundColor)
      ..writeByte(5)
      ..write(obj.speed)
      ..writeByte(6)
      ..write(obj.textColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
