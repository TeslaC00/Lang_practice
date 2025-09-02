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
  }) {
    LoggerService().d(
      'VerbForm created: verbWord=$verbWord, reading=${readings.join(', ')}, meaning=${meanings.join(", ")}',
    );
  }

  String displayTitle() {
    LoggerService().d('VerbForm.displayTitle called');
    final title = verbWord;
    LoggerService().d('VerbForm.displayTitle returning: $title');
    return title;
  }

  String displaySubtext() {
    LoggerService().d('VerbForm.displaySubtext called');
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
    LoggerService().d('VerbForm.displaySubtext returning: $result');
    return result;
  }

  String displaySummary() {
    LoggerService().d('VerbForm.displaySummary called');
    final meaningText = meanings.join(', ');
    final summary = '$verbWord ($readings) - $meaningText';
    LoggerService().d('VerbForm.displaySummary returning: $summary');
    return summary;
  }

  // ToJson method
  Map<String, dynamic> toJson() {
    LoggerService().d('VerbForm.toJson called for verbWord=$verbWord');
    return {
      'verbWord': verbWord,
      'reading': readings,
      'meaning': meanings,
    }; // meaning is already List<String>
  }

  // FromJson factory constructor
  factory VerbForm.fromJson(Map<String, dynamic> json) {
    LoggerService().d('VerbForm.fromJson called with json: $json');
    final instance = VerbForm(
      verbWord: json['verbWord'] as String,
      readings: json['reading'] as List<String>,
      meanings: json['meaning'] as List<String>,
    );
    LoggerService().d(
      'VerbForm.fromJson created instance: ${instance.verbWord}',
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
