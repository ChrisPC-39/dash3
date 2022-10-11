// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetupAdapter extends TypeAdapter<Setup> {
  @override
  final int typeId = 0;

  @override
  Setup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setup(
      theme: fields[0] as String,
      textSize: fields[1] as double,
      reverse: fields[2] as bool,
      useEnter: fields[3] as bool,
      boxSize: fields[4] as double,
      showIndicator: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Setup obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.theme)
      ..writeByte(1)
      ..write(obj.textSize)
      ..writeByte(2)
      ..write(obj.reverse)
      ..writeByte(3)
      ..write(obj.useEnter)
      ..writeByte(4)
      ..write(obj.boxSize)
      ..writeByte(5)
      ..write(obj.showIndicator);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
