// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VocabMetaAdapter extends TypeAdapter<VocabMeta> {
  @override
  final int typeId = 0;

  @override
  VocabMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VocabMeta(
      level: fields[0] as int,
      nextReview: fields[1] as DateTime?,
      isNew: fields[2] as bool,
      notes: fields[3] as String,
      totalCorrectTimes: fields[4] as int,
      totalWrongTimes: fields[5] as int,
      correctTimesCounter: fields[6] as int,
      wrongTimesCounter: fields[7] as int,
      lastReview: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, VocabMeta obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.nextReview)
      ..writeByte(2)
      ..write(obj.isNew)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.totalCorrectTimes)
      ..writeByte(5)
      ..write(obj.totalWrongTimes)
      ..writeByte(6)
      ..write(obj.correctTimesCounter)
      ..writeByte(7)
      ..write(obj.wrongTimesCounter)
      ..writeByte(8)
      ..write(obj.lastReview);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
