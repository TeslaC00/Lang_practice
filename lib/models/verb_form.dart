part of 'vocab.dart';

@HiveType(typeId: 5)
class VerbForm extends HiveObject {
  @HiveField(0)
  String verbWord;
  @HiveField(1)
  List<String> readings;
  @HiveField(2)
  List<String> meanings; // Changed to List<String>

  VerbForm({
    required this.verbWord,
    required this.readings,
    required this.meanings, // Changed to List<String>
  });

  String displayTitle() {
    final title = verbWord;
    return title;
  }

  String displaySubtext() {
    String result;
    final meaningText = meanings.join(', ');
    final readingText = readings.join(', ');
    if (readings.isEmpty && meanings.isEmpty) {
      result = '';
    } else if (readings.isEmpty) {
      result = meaningText;
    } else if (meanings.isEmpty) {
      result = readingText;
    } else {
      result = '$readingText - $meaningText';
    }
    return result;
  }

  String displaySummary() {
    final meaningText = meanings.join(', ');
    final summary = '$verbWord ($readings) - $meaningText';
    return summary;
  }

  // ToJson method
  Map<String, dynamic> toJson() {
    return {'verbWord': verbWord, 'readings': readings, 'meanings': meanings};
  }

  // FromJson factory constructor
  factory VerbForm.fromJson(Map<String, dynamic> json) {
    final instance = VerbForm(
      verbWord: json['verbWord'] as String,
      readings: List<String>.from(json['readings'] as List<dynamic>),
      meanings: List<String>.from(json['meanings'] as List<dynamic>),
    );
    return instance;
  }

  @override
  String toString() {
    return 'VerbForm{verbWord: $verbWord, reading: ${readings.join(', ')}, meaning: ${meanings.join(', ')}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerbForm &&
          runtimeType == other.runtimeType &&
          verbWord == other.verbWord &&
          readings == other.readings &&
          listEquals(meanings, other.meanings);

  @override
  int get hashCode =>
      verbWord.hashCode ^
      readings.hashCode ^
      meanings.fold(0, (prev, item) => prev ^ item.hashCode);
}
