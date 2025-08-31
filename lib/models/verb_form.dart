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
  }) {
    LoggerService().d(
      'VerbForm created: verbWord=$verbWord, reading=$reading, meaning=$meaning',
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
    if (reading.isEmpty && meaning.isEmpty) {
      result = '';
    } else if (reading.isEmpty) {
      result = meaning;
    } else if (meaning.isEmpty) {
      result = reading;
    } else {
      result = '$reading - $meaning';
    }
    LoggerService().d('VerbForm.displaySubtext returning: $result');
    return result;
  }

  String displaySummary() {
    LoggerService().d('VerbForm.displaySummary called');
    final summary = '$verbWord ($reading) - $meaning';
    LoggerService().d('VerbForm.displaySummary returning: $summary');
    return summary;
  }

  // ToJson method
  Map<String, dynamic> toJson() {
    LoggerService().d('VerbForm.toJson called for verbWord=$verbWord');
    return {'verbWord': verbWord, 'reading': reading, 'meaning': meaning};
  }

  // FromJson factory constructor
  factory VerbForm.fromJson(Map<String, dynamic> json) {
    LoggerService().d('VerbForm.fromJson called with json: $json');
    final instance = VerbForm(
      verbWord: json['verbWord'] as String,
      reading: json['reading'] as String,
      meaning: json['meaning'] as String,
    );
    LoggerService().d(
      'VerbForm.fromJson created instance: ${instance.verbWord}',
    );
    return instance;
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
