part of 'vocab.dart';

@HiveType(typeId: 4)
class SentenceVocab extends Vocab {
  @HiveField(3)
  String sentence;
  @HiveField(4)
  String answer;

  late TextEditingController _sentenceController;
  late TextEditingController _answerController;
  late TextEditingController _reviewAnswerController;
  late TextEditingController _notesController; // Added notes controller

  String _reviewFeedback = ''; // Feedback for the review screen

  SentenceVocab({
    required this.sentence,
    required this.answer,
    super.meta,
    super.notes,
  }) : super(type: VocabType.sentence) {
    LoggerService().d(
      'SentenceVocab created: "$sentence" - "$answer", Level: ${meta.level}',
    );
    _sentenceController = TextEditingController(text: sentence);
    _answerController = TextEditingController(text: answer);
    _reviewAnswerController = TextEditingController();
    _notesController = TextEditingController(
      text: notes,
    ); // Initialize notes controller
  }

  @override
  void dispose() {
    LoggerService().d('SentenceVocab.dispose called for "$sentence"');
    _sentenceController.dispose();
    _answerController.dispose();
    _reviewAnswerController.dispose();
    _notesController.dispose(); // Dispose notes controller
    // if Vocab has a dispose, call super.dispose();
  }

  // Helper method for review logic
  void _submitReviewAnswerLogic(
    TextEditingController controller,
    String correctAnswer,
    Function(String) feedbackSetter,
  ) {
    final userAnswer = controller.text.trim().toLowerCase();
    LoggerService().d(
      'SentenceVocab._submitReviewAnswerLogic: User answer: "$userAnswer", Correct: "$correctAnswer"',
    );
    if (correctAnswer.trim().toLowerCase() == userAnswer) {
      feedbackSetter("Correct!");
      LoggerService().i('SentenceVocab review: Correct for "$sentence"');
      SRS.markCorrect(this); // 'this' refers to SentenceVocab instance
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
        LoggerService().w('SentenceVocab review: Empty answer for "$sentence"');
      } else {
        feedbackSetter("Incorrect. Correct: $correctAnswer");
        LoggerService().w(
          'SentenceVocab review: Incorrect for "$sentence". User: "$userAnswer", Correct: "$correctAnswer"',
        );
        SRS.markWrong(this); // 'this' refers to SentenceVocab instance
      }
    }
  }

  @override
  List<Widget> buildFormFields(StateSetter setState) {
    LoggerService().d('SentenceVocab.buildFormFields called for "$sentence"');
    return [
      _LabeledField(
        'Sentence (use __ for blanks)',
        _sentenceController,
        maxLines: 3,
      ),
      const SizedBox(height: 10),
      _LabeledField('Answer/Translation', _answerController, maxLines: 3),
      const SizedBox(height: 10),
      _LabeledField('Notes', _notesController, maxLines: 3),
    ];
  }

  @override
  List<Widget> buildReviewFields(StateSetter setState) {
    LoggerService().d('SentenceVocab.buildReviewFields called for "$sentence"');
    return [
      Text(
        sentence,
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
        controller: _reviewAnswerController,
        decoration: InputDecoration(
          labelText: 'Your Answer',
          border: OutlineInputBorder(),
          hintText: 'Enter your translation or the missing part',
        ),
        onSubmitted: (_) => _submitReviewAnswerLogic(
          _reviewAnswerController,
          answer,
          (f) => setState(() => _reviewFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitReviewAnswerLogic(
          _reviewAnswerController,
          answer,
          (f) => setState(() => _reviewFeedback = f),
        ),
        child: const Text("Check Answer"),
      ),
      const SizedBox(height: 5),
      if (_reviewFeedback.isNotEmpty)
        Text(
          _reviewFeedback,
          style: TextStyle(
            color: _reviewFeedback == "Correct!" ? Colors.green : Colors.red,
          ),
        ),
    ];
  }

  @override
  String displayTitle() {
    return sentence.length > 30 ? '${sentence.substring(0, 30)}...' : sentence;
  }

  // displaySubtext remains specific to SentenceVocab showing the answer.
  // The generic level/review info is available via Vocab.displaySubtext if needed elsewhere.
  @override
  String displaySubtext() {
    return "$answer ${notes.isNotEmpty ? '\nNotes: $notes' : ''}";
  }

  @override
  String displaySummary() {
    // super.displaySummary() will now correctly include VocabMeta details
    return 'Sentence: "$sentence"\nAnswer: "$answer"\n${super.displaySummary()}';
  }

  @override
  Future<void> add() async {
    LoggerService().d(
      'SentenceVocab.add called. Old: "$sentence" - "$answer". New: "${_sentenceController.text}" - "${_answerController.text}"',
    );
    sentence = _sentenceController.text;
    answer = _answerController.text;
    notes = _notesController.text; // Update notes from controller
    await super
        .addToBox(); // This will save the Vocab object including its meta field
    LoggerService().i('SentenceVocab added: "$sentence"');
  }

  @override
  Future<void> save() async {
    LoggerService().d(
      'SentenceVocab.save called. Old: "$sentence" - "$answer". New: "${_sentenceController.text}" - "${_answerController.text}"',
    );
    sentence = _sentenceController.text;
    answer = _answerController.text;
    notes = _notesController.text; // Update notes from controller
    await super
        .save(); // This will save the Vocab object including its meta field
    LoggerService().i('SentenceVocab saved: "$sentence"');
  }

  @override
  String toString() {
    // Accessing meta for level and nextReview
    return 'SentenceVocab{sentence: $sentence, answer: $answer, type: $type, '
        'meta: ${meta.toString()}, notes: $notes}'; // Using meta.toString() for details
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && // super == other checks for key equality if HiveObject
          other is SentenceVocab &&
          runtimeType == other.runtimeType &&
          sentence == other.sentence &&
          answer == other.answer;

  @override
  int get hashCode => super.hashCode ^ sentence.hashCode ^ answer.hashCode;

  @override
  Map<String, dynamic> toJson() {
    LoggerService().d('SentenceVocab.toJson called for "$sentence"');
    final json = super.toJson(); // Gets type, notes and meta
    json.addAll({'sentence': sentence, 'answer': answer});
    return json;
  }

  static SentenceVocab fromJson(Map<String, dynamic> json) {
    LoggerService().d('SentenceVocab.fromJson called with data: $json');
    if (json['type'] != VocabType.sentence.name) {
      LoggerService().e(
        'Invalid type for SentenceVocab.fromJson: ${json['type']}. Expected ${VocabType.sentence.name}',
      );
      throw ArgumentError(
        'Invalid type for SentenceVocab.fromJson: ${json['type']}',
      );
    }

    // Extract and parse VocabMeta
    final metaJson = json['meta'] as Map<String, dynamic>?;
    final vocabMeta = metaJson != null
        ? VocabMeta.fromJson(metaJson)
        : VocabMeta(); // Or handle error if meta is strictly required

    final notes = json['notes'] as String? ?? ''; // Extract notes

    final vocab = SentenceVocab(
      sentence: json['sentence'] as String,
      answer: json['answer'] as String,
      meta: vocabMeta, // Pass parsed VocabMeta
      notes: notes,
    );
    // Level and nextReview are now part of meta, no need to set them directly.

    LoggerService().i(
      'SentenceVocab created from JSON: "${vocab.sentence}", Level: ${vocab.meta.level}',
    );
    return vocab;
  }
}
