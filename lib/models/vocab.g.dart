// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VocabTypeAdapter extends TypeAdapter<VocabType> {
  @override
  final int typeId = 1;

  @override
  VocabType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VocabType.word;
      case 1:
        return VocabType.verb;
      case 2:
        return VocabType.sentence;
      case 3:
        return VocabType.time;
      default:
        return VocabType.word;
    }
  }

  @override
  void write(BinaryWriter writer, VocabType obj) {
    switch (obj) {
      case VocabType.word:
        writer.writeByte(0);
        break;
      case VocabType.verb:
        writer.writeByte(1);
        break;
      case VocabType.sentence:
        writer.writeByte(2);
        break;
      case VocabType.time:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordVocabAdapter extends TypeAdapter<WordVocab> {
  @override
  final int typeId = 2;

  @override
  WordVocab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordVocab(
      word: fields[3] as String,
      readings: (fields[4] as List).cast<String>(),
      meanings: (fields[5] as List).cast<String>(),
      meta: fields[1] as VocabMeta?,
      notes: fields[2] as String,
    )..type = fields[0] as VocabType;
  }

  @override
  void write(BinaryWriter writer, WordVocab obj) {
    writer
      ..writeByte(6)
      ..writeByte(3)
      ..write(obj.word)
      ..writeByte(4)
      ..write(obj.readings)
      ..writeByte(5)
      ..write(obj.meanings)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.meta)
      ..writeByte(2)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordVocabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeVocabAdapter extends TypeAdapter<TimeVocab> {
  @override
  final int typeId = 3;

  @override
  TimeVocab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeVocab(
      timeWord: fields[3] as String,
      readings: (fields[4] as List).cast<String>(),
      timeString: fields[5] as String,
      meta: fields[1] as VocabMeta?,
      notes: fields[2] as String,
    )..type = fields[0] as VocabType;
  }

  @override
  void write(BinaryWriter writer, TimeVocab obj) {
    writer
      ..writeByte(6)
      ..writeByte(3)
      ..write(obj.timeWord)
      ..writeByte(4)
      ..write(obj.readings)
      ..writeByte(5)
      ..write(obj.timeString)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.meta)
      ..writeByte(2)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeVocabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SentenceVocabAdapter extends TypeAdapter<SentenceVocab> {
  @override
  final int typeId = 4;

  @override
  SentenceVocab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SentenceVocab(
      sentence: fields[3] as String,
      answer: fields[4] as String,
      meta: fields[1] as VocabMeta?,
      notes: fields[2] as String,
    )..type = fields[0] as VocabType;
  }

  @override
  void write(BinaryWriter writer, SentenceVocab obj) {
    writer
      ..writeByte(5)
      ..writeByte(3)
      ..write(obj.sentence)
      ..writeByte(4)
      ..write(obj.answer)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.meta)
      ..writeByte(2)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SentenceVocabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VerbFormAdapter extends TypeAdapter<VerbForm> {
  @override
  final int typeId = 5;

  @override
  VerbForm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerbForm(
      verbWord: fields[0] as String,
      readings: (fields[1] as List).cast<String>(),
      meanings: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, VerbForm obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.verbWord)
      ..writeByte(1)
      ..write(obj.readings)
      ..writeByte(2)
      ..write(obj.meanings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerbFormAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VerbVocabAdapter extends TypeAdapter<VerbVocab> {
  @override
  final int typeId = 6;

  @override
  VerbVocab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerbVocab(
      plainVerb: fields[3] as VerbForm,
      verbForms: (fields[4] as Map).cast<String, VerbForm>(),
      meta: fields[1] as VocabMeta?,
      notes: fields[2] as String,
    )..type = fields[0] as VocabType;
  }

  @override
  void write(BinaryWriter writer, VerbVocab obj) {
    writer
      ..writeByte(5)
      ..writeByte(3)
      ..write(obj.plainVerb)
      ..writeByte(4)
      ..write(obj.verbForms)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.meta)
      ..writeByte(2)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerbVocabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
