part of 'vocab.dart';

@HiveType(typeId: 5)
class VerbForm extends HiveObject {
  @HiveField(0)
  String verbWord;
  @HiveField(1)
  String reading;
  @HiveField(2)
  String meaning;

  VerbForm({
    required this.verbWord,
    required this.reading,
    required this.meaning,
  });

  String displayTitle() {
    return verbWord;
  }

  String displaySubtext() {
    if (reading.isEmpty && meaning.isEmpty) return '';
    if (reading.isEmpty) return meaning;
    if (meaning.isEmpty) return reading;
    return '$reading - $meaning';
  }

  String displaySummary() {
    return '$verbWord ($reading) - $meaning';
  }

  @override
  String toString() {
    return 'VerbForm{verbWord: $verbWord, reading: $reading, meaning: $meaning}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerbForm &&
          runtimeType == other.runtimeType &&
          verbWord == other.verbWord &&
          reading == other.reading &&
          meaning == other.meaning;

  @override
  int get hashCode => verbWord.hashCode ^ reading.hashCode ^ meaning.hashCode;
}