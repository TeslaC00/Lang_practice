part of 'vocab.dart';

@HiveType(typeId: 2)
class WordVocab extends Vocab {
  @HiveField(4)
  String word;
  @HiveField(5)
  List<String> readings;
  @HiveField(6)
  List<String> meanings;

  late TextEditingController _wordController;
  late TextEditingController _meaningsController;
  late TextEditingController _readingsController;

  WordVocab({
    required this.word,
    required this.readings,
    required this.meanings,
  }) : super(type: VocabType.word) {
    _wordController = TextEditingController(text: word);
    _meaningsController = TextEditingController(text: meanings.join(', '));
    _readingsController = TextEditingController(text: readings.join(', '));
  }

  @override
  List<Widget> buildFormFields(StateSetter setState) {
    return [
      _LabeledField('Word (kanji/word)', _wordController),
      const SizedBox(height: 10),
      _LabeledField(
        'Readings (ひらがな etc., comma separated)',
        _readingsController,
      ),
      const SizedBox(height: 10),
      _LabeledField('Meanings/English (comma separated)', _meaningsController),
      const SizedBox(height: 10),
    ];
  }

  @override
  String displayTitle() {
    return word;
  }

  @override
  String displaySubtext() {
    String readingSub = readings.isNotEmpty ? readings.first : 'N/A';
    String meaningSub = meanings.isNotEmpty ? meanings.first : 'N/A';
    if (readingSub == 'N/A' && meaningSub == 'N/A') return '';
    if (readingSub == 'N/A') return meaningSub;
    if (meaningSub == 'N/A') return readingSub;
    return '$readingSub - $meaningSub';
  }

  @override
  String displaySummary() {
    String readingSummary = readings.isNotEmpty ? readings.first : 'N/A';
    String meaningSummary = meanings.isNotEmpty ? meanings.first : 'N/A';
    return 'Word: $word (Reading: $readingSummary, Meaning: $meaningSummary)\n${super.displaySummary()}';
  }

  @override
  Future<void> save() async {
    word = _wordController.text;
    readings = _readingsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    meanings = _meaningsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    await super.save();
  }

  @override
  String toString() {
    return 'WordVocab{word: $word, readings: $readings, meanings: $meanings, '
        'type: $type, level: $level, nextReview: $nextReview}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is WordVocab &&
          runtimeType == other.runtimeType &&
          word == other.word &&
          listEquals(readings, other.readings) &&
          listEquals(meanings, other.meanings);

  @override
  int get hashCode =>
      super.hashCode ^ word.hashCode ^ readings.hashCode ^ meanings.hashCode;
}
