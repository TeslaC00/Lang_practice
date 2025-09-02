part of 'vocab.dart';

@HiveType(typeId: 6)
class VerbVocab extends Vocab {
  @HiveField(3)
  VerbForm plainVerb;

  @HiveField(4)
  Map<String, VerbForm> verbForms; // Key is the form name e.g., "Past Polite"

  late TextEditingController _plainVerbWordController;
  late TextEditingController _plainVerbReadingController;
  late TextEditingController _plainVerbMeaningController;
  late TextEditingController _notesController;

  // Review screen controllers
  late TextEditingController _readingAnswerController;
  late TextEditingController _meaningAnswerController;

  String _readingFeedback = '';
  String _meaningFeedback = '';

  VerbVocab({
    required this.plainVerb,
    required this.verbForms,
    super.meta,
    super.notes,
  }) : super(type: VocabType.verb) {
    LoggerService().d(
      'VerbVocab constructor: plainVerb=${plainVerb.verbWord}, verbForms count=${verbForms.length}, '
      'meta: $meta',
    );
    _plainVerbWordController = TextEditingController(text: plainVerb.verbWord);
    _plainVerbReadingController = TextEditingController(
      text: plainVerb.readings.join(', '),
    );
    _plainVerbMeaningController = TextEditingController(
      text: plainVerb.meanings.join(', '),
    );
    _notesController = TextEditingController(text: notes);
    _readingAnswerController = TextEditingController();
    _meaningAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    LoggerService().d('VerbVocab dispose: Disposing controllers');
    _plainVerbWordController.dispose();
    _plainVerbReadingController.dispose();
    _plainVerbMeaningController.dispose();
    _notesController.dispose();
    _readingAnswerController.dispose();
    _meaningAnswerController.dispose();
  }

  void _submitReviewAnswerLogic(
    TextEditingController controller,
    List<String> correctAnswers,
    Function(String) feedbackSetter,
  ) {
    final userAnswer = controller.text.trim().toLowerCase();
    LoggerService().d(
      'VerbVocab _submitReviewAnswerLogic: userAnswer="$userAnswer", correctAnswer="${correctAnswers.join(', ')}"',
    );
    // SRS interaction will now use this.meta
    if (correctAnswers
        .map((ans) => ans.trim().toLowerCase())
        .contains(userAnswer)) {
      feedbackSetter("Correct!");
      LoggerService().i(
        'VerbVocab _submitReviewAnswerLogic: Correct answer. Marking correct.',
      );
      SRS.markCorrect(this);
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
        LoggerService().w('VerbVocab _submitReviewAnswerLogic: Empty answer.');
      } else {
        feedbackSetter("Incorrect. Correct: $correctAnswers");
        LoggerService().i(
          'VerbVocab _submitReviewAnswerLogic: Incorrect answer. Correct: $correctAnswers. Marking wrong.',
        );
        SRS.markWrong(this);
      }
    }
  }

  @override
  List<Widget> buildFormFields(StateSetter setState) {
    LoggerService().d('VerbVocab buildFormFields entry');
    List<Widget> formWidgets = [
      _LabeledField('Plain Verb Word (e.g., 食べる)', _plainVerbWordController),
      const SizedBox(height: 10),
      _LabeledField(
        'Plain Verb Reading (e.g., たべる)',
        _plainVerbReadingController,
      ),
      const SizedBox(height: 10),
      _LabeledField(
        'Plain Verb Meaning(s) (e.g., to eat, to consume - comma separated)',
        _plainVerbMeaningController,
      ),
      const SizedBox(height: 10),
      _LabeledField('Notes', _notesController, maxLines: 3),
      const SizedBox(height: 10),
      const Text('Verb Forms:', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
    ];

    verbForms.forEach((key, verbForm) {
      formWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
          child: Text('$key: ${verbForm.displaySummary()}'),
        ),
      );
    });

    return formWidgets;
  }

  @override
  List<Widget> buildReviewFields(StateSetter setState) {
    LoggerService().d('VerbVocab buildReviewFields entry');
    return [
      Text(
        plainVerb.verbWord,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      if (notes.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Notes: $notes",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      const SizedBox(height: 10),
      TextField(
        controller: _readingAnswerController,
        decoration: InputDecoration(
          labelText: 'Reading of Plain Form',
          border: OutlineInputBorder(),
          hintText: 'Enter reading in hiragana/katakana',
        ),
        onSubmitted: (_) => _submitReviewAnswerLogic(
          _readingAnswerController,
          plainVerb.readings,
          (f) => setState(() => _readingFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitReviewAnswerLogic(
          _readingAnswerController,
          plainVerb.readings,
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
          labelText: 'Meaning of Plain Form',
          border: OutlineInputBorder(),
          hintText: 'Enter meaning in English',
        ),
        onSubmitted: (_) => _submitReviewAnswerLogic(
          _meaningAnswerController,
          plainVerb.meanings,
          (f) => setState(() => _meaningFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitReviewAnswerLogic(
          _meaningAnswerController,
          plainVerb.meanings,
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
    return plainVerb.displayTitle();
  }

  @override
  String displaySubtext() {
    String plainVerbSubtext = plainVerb.displaySubtext();
    String formsCount = verbForms.isEmpty ? '' : 'Forms: ${verbForms.length}';

    List<String> parts = [];
    if (plainVerbSubtext.isNotEmpty) parts.add(plainVerbSubtext);
    parts.add(formsCount);
    if (notes.isNotEmpty) parts.add('\nNotes: $notes');

    return parts.join(' | ');
  }

  @override
  String displaySummary() {
    return 'Verb: ${plainVerb.displaySummary()}\nForms: ${verbForms.length}\n'
        '${super.displaySummary()}';
  }

  @override
  Future<void> add() async {
    LoggerService().d(
      'VerbVocab add: Saving plainVerb. Word: "${_plainVerbWordController.text}", '
      'Reading: "${_plainVerbReadingController.text}", '
      'Meaning(s) from input: "${_plainVerbMeaningController.text}"',
    );
    plainVerb.verbWord = _plainVerbWordController.text.trim();
    plainVerb.readings = _plainVerbReadingController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    plainVerb.meanings = _plainVerbMeaningController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    notes = _notesController.text.trim();
    await super.addToBox();
    LoggerService().i(
      'VerbVocab add: Added to box. Key: $key. Meanings: ${plainVerb.meanings}',
    );
  }

  @override
  Future<void> save() async {
    LoggerService().d(
      'VerbVocab save: Saving plainVerb. Word: "${_plainVerbWordController.text}", Reading: "${_plainVerbReadingController.text}", Meaning(s) from input: "${_plainVerbMeaningController.text}"',
    );
    plainVerb.verbWord = _plainVerbWordController.text.trim();
    plainVerb.readings = _plainVerbReadingController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    plainVerb.meanings = _plainVerbMeaningController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    notes = _notesController.text.trim();
    await super.save();
    LoggerService().i(
      'VerbVocab save: Save complete. Key: $key. Meanings: ${plainVerb.meanings}',
    );
  }

  @override
  String toString() {
    // super.toString() already includes meta.
    return 'VerbVocab{plainVerb: $plainVerb, verbForms: ${verbForms.length}, ${super.toString()}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is VerbVocab &&
          runtimeType == other.runtimeType &&
          plainVerb == other.plainVerb &&
          mapEquals(verbForms, other.verbForms);

  @override
  int get hashCode => super.hashCode ^ plainVerb.hashCode ^ verbForms.hashCode;

  @override
  Map<String, dynamic> toJson() {
    LoggerService().d('VerbVocab toJson entry');
    final jsonMap = super.toJson(); // Gets 'type' and 'meta'
    jsonMap.addAll({
      'plainVerb': plainVerb.toJson(),
      // Assumes VerbForm has toJson()
      'verbForms': verbForms.map((key, value) => MapEntry(key, value.toJson())),
      // Assumes VerbForm has toJson()
    });
    return jsonMap;
  }

  static VerbVocab fromJson(Map<String, dynamic> json) {
    LoggerService().d(
      'VerbVocab fromJson: Attempting to create VerbVocab from JSON: '
      '${json.toString().substring(0, json.toString().length > 200 ? 200 : json.toString().length)}',
    );

    final typeStr = json['type'] as String?;
    if (typeStr != VocabType.verb.name) {
      final errorMsg =
          'VerbVocab.fromJson error: Invalid type. Expected ${VocabType.verb.name}, got $typeStr';
      LoggerService().e(errorMsg, 'Invalid type in JSON', StackTrace.current);
      throw ArgumentError(errorMsg);
    }

    final metaJson = json['meta'] as Map<String, dynamic>?;
    final vocabMeta = metaJson != null
        ? VocabMeta.fromJson(metaJson)
        : VocabMeta(); // Default if null

    final notes = json['notes'] as String? ?? ''; // Extract notes

    final plainVerbData = json['plainVerb'] as Map<String, dynamic>?;
    if (plainVerbData == null) {
      final errorMsg =
          'VerbVocab.fromJson error: "plainVerb" field is missing or not a map.';
      LoggerService().e(
        errorMsg,
        'Missing plainVerb in JSON',
        StackTrace.current,
      );
      throw ArgumentError(errorMsg);
    }
    final VerbForm plainVerb = VerbForm.fromJson(plainVerbData);

    final verbFormsData = json['verbForms'] as Map<String, dynamic>? ?? {};
    final Map<String, VerbForm> verbForms = verbFormsData.map(
      (key, value) =>
          MapEntry(key, VerbForm.fromJson(value as Map<String, dynamic>)),
    );

    final vocab = VerbVocab(
      plainVerb: plainVerb,
      verbForms: verbForms,
      meta: vocabMeta, // Pass the parsed meta object
      notes: notes,
    );

    LoggerService().i(
      'VerbVocab fromJson: Successfully created VerbVocab: ${vocab.plainVerb.verbWord} with meta: ${vocab.meta}',
    );
    return vocab;
  }
}
