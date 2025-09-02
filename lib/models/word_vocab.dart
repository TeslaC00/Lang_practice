part of 'vocab.dart';

@HiveType(typeId: 2)
class WordVocab extends Vocab {
  @HiveField(3)
  String word;
  @HiveField(4)
  List<String> readings;
  @HiveField(5)
  List<String> meanings;

  late TextEditingController _wordController;
  late TextEditingController _meaningsController;
  late TextEditingController _readingsController;
  late TextEditingController _readingAnswerController;
  late TextEditingController _meaningAnswerController;
  late TextEditingController _notesController; // Added notes controller

  // Notes controller is no longer needed here if notes are handled by a general field in Vocab
  // or AddEditScreen directly uses vocab.notes.
  // However, if buildFormFields for WordVocab specifically adds a notes field, it would use vocab.notes.

  String _readingFeedback = '';
  String _meaningFeedback = '';

  WordVocab({
    required this.word,
    required this.readings,
    required this.meanings,
    super.meta,
    super.notes,
  }) : super(type: VocabType.word) {
    LoggerService().d(
      'WordVocab created: word=$word, readings=$readings, meanings=$meanings, notes=$notes, level=${meta.level}',
    );
    _wordController = TextEditingController(text: word);
    _meaningsController = TextEditingController(text: meanings.join(', '));
    _readingsController = TextEditingController(text: readings.join(', '));
    _readingAnswerController = TextEditingController();
    _meaningAnswerController = TextEditingController();
    _notesController = TextEditingController(text: notes); // Initialize notes controller
  }

  @override
  void dispose() {
    LoggerService().d('WordVocab.dispose called for word: $word');
    _wordController.dispose();
    _meaningsController.dispose();
    _readingsController.dispose();
    _readingAnswerController.dispose();
    _meaningAnswerController.dispose();
    _notesController.dispose(); // Dispose notes controller
    // super.dispose(); // If Vocab base class had a dispose method.
  }

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
    LoggerService().d(
      'WordVocab.buildFormFields called for word: $word, notes: $notes',
    );
    // Note: A general notes field might be added by the AddEditVocabScreen itself,
    // or if each vocab type has specific notes, it could be handled here.
    // Assuming general notes are handled elsewhere or via a shared method in Vocab.
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
      _LabeledField('Notes', _notesController), // Added notes field
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
      if (notes.isNotEmpty) // Display notes if they exist
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Notes: $notes", // Notes are already displayed here
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
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
    List<String> parts = [];
    if (readingSub.isNotEmpty) parts.add(readingSub);
    if (meaningSub.isNotEmpty) parts.add(meaningSub);
    if (notes.isNotEmpty) parts.add('Notes: $notes');

    return parts.join(' | ');
  }

  @override
  String displaySummary() {
    String readingSummary = readings.isNotEmpty ? readings.join(', ') : 'N/A';
    String meaningSummary = meanings.isNotEmpty ? meanings.join(', ') : 'N/A';
    // super.displaySummary() already includes notes now.
    return 'Word: $word (Reading: $readingSummary, Meaning: $meaningSummary)\n${super.displaySummary()}';
  }

  @override
  Future<void> add() async {
    LoggerService().d('WordVocab.add called for current word: $word');
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
    notes = _notesController.text; // Update notes from controller
    LoggerService().i(
      'WordVocab adding: word=$word, readings=$readings, meanings=$meanings, notes=$notes, level=${meta.level}',
    );
    await super.addToBox();
  }

  // TODO: Add notes controller in all subclasses for adding and editing
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
    notes = _notesController.text; // Update notes from controller
    LoggerService().i(
      'WordVocab saving: word=$word, readings=$readings, meanings=$meanings, notes=$notes, level=${meta.level}',
    );
    await super.save();
  }

  @override
  String toString() {
    return 'WordVocab{word: $word, readings: $readings, meanings: $meanings, notes: $notes, ${meta.toString()}}';
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

  // notes comparison is handled by super == other

  @override
  int get hashCode =>
      super.hashCode ^
      word.hashCode ^
      readings.fold(0, (prev, item) => prev ^ item.hashCode) ^
      meanings.fold(0, (prev, item) => prev ^ item.hashCode);

  // notes hash is included in super.hashCode

  @override
  Map<String, dynamic> toJson() {
    LoggerService().d('WordVocab.toJson called for word: $word');
    final json = super.toJson(); // Gets 'type', 'notes', and 'meta'
    json.addAll({'word': word, 'readings': readings, 'meanings': meanings});
    return json;
  }

  factory WordVocab.fromJson(Map<String, dynamic> json) {
    LoggerService().d('WordVocab.fromJson called with json: $json');

    final metaJson = json['meta'] as Map<String, dynamic>?;
    final vocabMeta = metaJson != null
        ? VocabMeta.fromJson(metaJson)
        : VocabMeta();

    final notes = json['notes'] as String? ?? ''; // Extract notes

    final vocab = WordVocab(
      word: json['word'] as String,
      readings: List<String>.from(json['readings'] as List<dynamic>),
      meanings: List<String>.from(json['meanings'] as List<dynamic>),
      meta: vocabMeta,
      notes: notes,
    );
    LoggerService().i(
      'WordVocab created from json: ${vocab.word}, notes: ${vocab.notes}, level: ${vocab.meta.level}',
    );
    return vocab;
  }
}
