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
      word: fields[4] as String,
      readings: (fields[5] as List).cast<String>(),
      meanings: (fields[6] as List).cast<String>(),
    )
      ..type = fields[1] as VocabType
      ..level = fields[2] as int
      ..nextReview = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, WordVocab obj) {
    writer
      ..writeByte(6)
      ..writeByte(4)
      ..write(obj.word)
      ..writeByte(5)
      ..write(obj.readings)
      ..writeByte(6)
      ..write(obj.meanings)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.nextReview);
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
      timeWord: fields[4] as String,
      reading: fields[5] as String,
      timeString: fields[6] as String,
    )
      ..type = fields[1] as VocabType
      ..level = fields[2] as int
      ..nextReview = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, TimeVocab obj) {
    writer
      ..writeByte(6)
      ..writeByte(4)
      ..write(obj.timeWord)
      ..writeByte(5)
      ..write(obj.reading)
      ..writeByte(6)
      ..write(obj.timeString)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.nextReview);
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
      sentence: fields[4] as String,
      answer: fields[5] as String,
    )
      ..type = fields[1] as VocabType
      ..level = fields[2] as int
      ..nextReview = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, SentenceVocab obj) {
    writer
      ..writeByte(5)
      ..writeByte(4)
      ..write(obj.sentence)
      ..writeByte(5)
      ..write(obj.answer)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.nextReview);
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
      reading: fields[1] as String,
      meaning: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VerbForm obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.verbWord)
      ..writeByte(1)
      ..write(obj.reading)
      ..writeByte(2)
      ..write(obj.meaning);
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
      plainVerb: fields[4] as VerbForm,
      verbForms: (fields[5] as Map).cast<String, VerbForm>(),
    )
      ..type = fields[1] as VocabType
      ..level = fields[2] as int
      ..nextReview = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, VerbVocab obj) {
    writer
      ..writeByte(5)
      ..writeByte(4)
      ..write(obj.plainVerb)
      ..writeByte(5)
      ..write(obj.verbForms)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.nextReview);
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
