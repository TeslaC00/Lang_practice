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

  String _readingFeedback = '';
  String _meaningFeedback = '';

  WordVocab({
    required this.word,
    required this.readings,
    required this.meanings,
    super.meta,
    super.notes,
  }) : super(type: VocabType.word) {
    _wordController = TextEditingController(text: word);
    _meaningsController = TextEditingController(text: meanings.join(', '));
    _readingsController = TextEditingController(text: readings.join(', '));
    _readingAnswerController = TextEditingController();
    _meaningAnswerController = TextEditingController();
    _notesController = TextEditingController(
      text: notes,
    ); // Initialize notes controller
  }

  @override
  void dispose() {
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
    if (correctAnswers.any((ans) => ans.trim().toLowerCase() == userAnswer)) {
      feedbackSetter("Correct!");
      SRS.markCorrect(this);
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
      } else {
        feedbackSetter("Incorrect. Correct: ${correctAnswers.join(', ')}");
        SRS.markWrong(this);
      }
    }
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
      _LabeledField('Notes', _notesController, maxLines: 3),
      // Added notes field
    ];
  }

  @override
  List<Widget> buildReviewFields(StateSetter setState) {
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
      if (notes.isNotEmpty) // Display notes if they exist
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Notes: $notes",
            style: TextStyle(fontStyle: FontStyle.italic),
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
    if (notes.isNotEmpty) parts.add('\nNotes: $notes');

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
    await super.addToBox();
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
    notes = _notesController.text; // Update notes from controller
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
    final json = super.toJson(); // Gets 'type', 'notes', and 'meta'
    json.addAll({'word': word, 'readings': readings, 'meanings': meanings});
    return json;
  }

  factory WordVocab.fromJson(Map<String, dynamic> json) {
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
    return vocab;
  }
}
