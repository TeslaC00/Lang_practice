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
  late TextEditingController _readingAnswerController;
  late TextEditingController _meaningAnswerController;

  String _readingFeedback = ''; // Initialized
  String _meaningFeedback = ''; // Initialized

  WordVocab({
    required this.word,
    required this.readings,
    required this.meanings,
  }) : super(type: VocabType.word) {
    LoggerService().d(
      'WordVocab created: word=$word, readings=$readings, meanings=$meanings',
    );
    _wordController = TextEditingController(text: word);
    _meaningsController = TextEditingController(text: meanings.join(', '));
    _readingsController = TextEditingController(text: readings.join(', '));
    _readingAnswerController = TextEditingController();
    _meaningAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    LoggerService().d('WordVocab.dispose called for word: $word');
    _wordController.dispose();
    _meaningsController.dispose();
    _readingsController.dispose();
    _readingAnswerController.dispose();
    _meaningAnswerController.dispose();
    // if Vocab has a dispose, call super.dispose();
  }

  // Helper method for form fields, assuming _LabeledField is defined elsewhere (e.g. in vocab.dart)
  // Widget _LabeledField(String label, TextEditingController controller) { ... }

  // Helper method for review logic
  void _submitAnswerLogic(
    TextEditingController controller,
    List<String> correctAnswers,
    Function(String) feedbackSetter,
  ) {
    final userAnswer = controller.text.trim().toLowerCase();
    LoggerService().d(
      'WordVocab._submitAnswerLogic: userAnswer="$userAnswer", correctAnswers="$correctAnswers" for word="$word"',
    );
    if (correctAnswers.any((ans) => ans.trim().toLowerCase() == userAnswer)) {
      feedbackSetter("Correct!");
      LoggerService().i(
        'WordVocab._submitAnswerLogic: Correct answer for "$word"',
      );
      SRS.markCorrect(this);
      LoggerService().d(
        'WordVocab._submitAnswerLogic: SRS.markCorrect called for "$word"',
      );
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
        LoggerService().w(
          'WordVocab._submitAnswerLogic: Empty answer for "$word"',
        );
      } else {
        feedbackSetter("Incorrect. Correct: ${correctAnswers.join(', ')}");
        LoggerService().w(
          'WordVocab._submitAnswerLogic: Incorrect answer for "$word"',
        );
        SRS.markWrong(this);
        LoggerService().d(
          'WordVocab._submitAnswerLogic: SRS.markWrong called for "$word"',
        );
      }
    }
  }

  @override
  List<Widget> buildFormFields(StateSetter setState) {
    LoggerService().d('WordVocab.buildFormFields called for word: $word');
    // This assumes _LabeledField is available in the scope.
    // If _LabeledField is defined in Vocab, WordVocab, or imported, this will work.
    // Example: Widget _LabeledField(String label, TextEditingController controller) => Column(...);

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
  List<Widget> buildReviewFields(StateSetter setState) {
    LoggerService().d('WordVocab.buildReviewFields called for word: $word');
    return [
      Text(
        word,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      TextField(
        controller: _readingAnswerController,
        decoration: InputDecoration(
          labelText: 'Give Reading',
          border: OutlineInputBorder(),
          hintText: 'Enter reading in hiragana/katakana',
        ),
        onSubmitted: (_) => _submitAnswerLogic(
          _readingAnswerController,
          readings,
          (f) => setState(() => _readingFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitAnswerLogic(
          _readingAnswerController,
          readings,
          (f) => setState(() => _readingFeedback = f),
        ),
        child: const Text("Check Reading"),
      ),
      const SizedBox(height: 5),
      if (_readingFeedback.isNotEmpty)
        Text(
          _readingFeedback,
          style: TextStyle(
            color: _readingFeedback == "Correct!" ? Colors.green : Colors.red,
          ),
        ),
      const SizedBox(height: 10),
      TextField(
        controller: _meaningAnswerController,
        decoration: InputDecoration(
          labelText: 'Give Meaning',
          border: OutlineInputBorder(),
          hintText: 'Enter meaning in English',
        ),
        onSubmitted: (_) => _submitAnswerLogic(
          _meaningAnswerController,
          meanings,
          (f) => setState(() => _meaningFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitAnswerLogic(
          _meaningAnswerController,
          meanings,
          (f) => setState(() => _meaningFeedback = f),
        ),
        child: const Text("Check Meaning"),
      ),
      const SizedBox(height: 5),
      if (_meaningFeedback.isNotEmpty)
        Text(
          _meaningFeedback,
          style: TextStyle(
            color: _meaningFeedback == "Correct!" ? Colors.green : Colors.red,
          ),
        ),
    ];
  }

  @override
  String displayTitle() {
    return word;
  }

  @override
  String displaySubtext() {
    String readingSub = readings.join(', ');
    String meaningSub = meanings.join(', ');
    if (readingSub.isEmpty && meaningSub.isEmpty) return '';
    if (readingSub.isEmpty) return meaningSub;
    if (meaningSub.isEmpty) return readingSub;
    return '$readingSub - $meaningSub';
  }

  @override
  String displaySummary() {
    String readingSummary = readings.isNotEmpty ? readings.join(', ') : 'N/A';
    String meaningSummary = meanings.isNotEmpty ? meanings.join(', ') : 'N/A';
    return 'Word: $word (Reading: $readingSummary, Meaning: $meaningSummary)\n${super.displaySummary()}';
  }

  @override
  Future<void> save() async {
    LoggerService().d('WordVocab.save called for current word: $word');
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
    LoggerService().i(
      'WordVocab saving: word=$word, readings=$readings, meanings=$meanings',
    );
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
      super.hashCode ^
      word.hashCode ^
      readings.fold(0, (prev, item) => prev ^ item.hashCode) ^
      meanings.fold(0, (prev, item) => prev ^ item.hashCode);

  @override
  Map<String, dynamic> toJson() {
    LoggerService().d('WordVocab.toJson called for word: $word');
    return {
      'type': type.name,
      'level': level,
      'nextReview': nextReview.toIso8601String(),
      'word': word,
      'readings': readings,
      'meanings': meanings,
    };
  }

  factory WordVocab.fromJson(Map<String, dynamic> json) {
    LoggerService().d('WordVocab.fromJson called with json: $json');
    if (json['type'] != VocabType.word.name) {
      LoggerService().e(
        'Invalid type for WordVocab.fromJson: ${json['type']}. Expected ${VocabType.word.name}',
      );
      throw ArgumentError(
        'Invalid type for WordVocab.fromJson: ${json['type']}',
      );
    }
    final vocab = WordVocab(
      word: json['word'] as String,
      readings: List<String>.from(json['readings'] as List<dynamic>),
      meanings: List<String>.from(json['meanings'] as List<dynamic>),
    );
    vocab.level = json['level'] as int;
    vocab.nextReview = DateTime.parse(json['nextReview'] as String);
    LoggerService().i('WordVocab created from json: ${vocab.word}');
    return vocab;
  }
}
