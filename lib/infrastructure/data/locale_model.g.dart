// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocaleModelAdapter extends TypeAdapter<LocaleModel> {
  @override
  final int typeId = 1;

  @override
  LocaleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocaleModel(
      languageCode: fields[0] as String,
      scriptCode: fields[1] as String,
      countryCode: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocaleModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.languageCode)
      ..writeByte(1)
      ..write(obj.scriptCode)
      ..writeByte(2)
      ..write(obj.countryCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
