// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmAdapter extends TypeAdapter<Alarm> {
  @override
  final int typeId = 0;

  @override
  Alarm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Alarm(
      label: fields[0] as String?,
      time: fields[1] as DateTime?,
      color: fields[2] as int,
      selectedDays: (fields[4] as List).cast<bool>(),
    )..key = fields[3] as int?;
  }

  @override
  void write(BinaryWriter writer, Alarm obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.key)
      ..writeByte(4)
      ..write(obj.selectedDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
