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
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      lastUsed: fields[3] as String,
      speed: fields[4] as ESpeed,
      textColorIndex: fields[5] as int,
      backgroundColorIndex: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Led obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.lastUsed)
      ..writeByte(4)
      ..write(obj.speed)
      ..writeByte(5)
      ..write(obj.textColorIndex)
      ..writeByte(6)
      ..write(obj.backgroundColorIndex);
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
