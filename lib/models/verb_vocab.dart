part of 'vocab.dart';

@HiveType(typeId: 6)
class VerbVocab extends Vocab {
  @HiveField(4)
  VerbForm plainVerb;
  @HiveField(5)
  Map<String, VerbForm> verbForms; // Key is the form name e.g., "Past Polite"

  late TextEditingController _plainVerbWordController;
  late TextEditingController _plainVerbReadingController;
  late TextEditingController _plainVerbMeaningController;

  // Review screen controllers
  late TextEditingController _readingAnswerController;
  late TextEditingController _meaningAnswerController;

  String _readingFeedback = '';
  String _meaningFeedback = '';

  // TODO: Add controllers for verbForms if they are to be made editable in this form
  VerbVocab({required this.plainVerb, required this.verbForms})
    : super(type: VocabType.verb) {
    LoggerService().d(
      'VerbVocab constructor: plainVerb=${plainVerb.verbWord}, verbForms count=${verbForms.length}',
    );
    _plainVerbWordController = TextEditingController(text: plainVerb.verbWord);
    _plainVerbReadingController = TextEditingController(
      text: plainVerb.reading,
    );
    _plainVerbMeaningController = TextEditingController(
      text: plainVerb.meaning,
    );
    _readingAnswerController = TextEditingController();
    _meaningAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    LoggerService().d('VerbVocab dispose: Disposing controllers');
    _plainVerbWordController.dispose();
    _plainVerbReadingController.dispose();
    _plainVerbMeaningController.dispose();
    _readingAnswerController.dispose();
    _meaningAnswerController.dispose();
    // if Vocab has a dispose, call super.dispose();
  }

  void _submitReviewAnswerLogic(
    TextEditingController controller,
    String correctAnswer,
    Function(String) feedbackSetter,
  ) {
    final userAnswer = controller.text.trim().toLowerCase();
    LoggerService().d(
      'VerbVocab _submitReviewAnswerLogic: userAnswer="$userAnswer", correctAnswer="$correctAnswer"',
    );
    if (correctAnswer.trim().toLowerCase() == userAnswer) {
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
        feedbackSetter("Incorrect. Correct: $correctAnswer");
        LoggerService().i(
          'VerbVocab _submitReviewAnswerLogic: Incorrect answer. Correct: $correctAnswer. Marking wrong.',
        );
        SRS.markWrong(this);
      }
    }
  }

  // TODO: Implement a more comprehensive form for verbForms if needed.
  // This could involve dynamically adding/removing fields for each VerbForm in the HashMap.
  // For now, only plainVerb is directly editable.
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
        'Plain Verb Meaning (e.g., to eat)',
        _plainVerbMeaningController,
      ),
      const SizedBox(height: 10),
      const Text('Verb Forms:', style: TextStyle(fontWeight: FontWeight.bold)),
      // Display existing verb forms (read-only in this basic implementation)
      // A more complex UI would be needed to edit these directly here.
    ];

    verbForms.forEach((key, verbForm) {
      formWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
          child: Text('$key: ${verbForm.displaySummary()}'),
        ),
      );
    });
    formWidgets.add(const SizedBox(height: 10));

    return formWidgets;
  }

  @override
  List<Widget> buildReviewFields(StateSetter setState) {
    LoggerService().d('VerbVocab buildReviewFields entry');
    // For VerbVocab, let's review the plain form's reading and meaning.
    // You could extend this to randomly pick a form or cycle through them.
    return [
      Text(
        plainVerb.verbWord, // Show the plain verb word
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          plainVerb.reading,
          (f) => setState(() => _readingFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitReviewAnswerLogic(
          _readingAnswerController,
          plainVerb.reading,
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
          plainVerb.meaning,
          (f) => setState(() => _meaningFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitReviewAnswerLogic(
          _meaningAnswerController,
          plainVerb.meaning,
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
    if (plainVerbSubtext.isEmpty) {
      return 'Forms: ${verbForms.length}';
    }
    return '${plainVerb.displaySubtext()} | Forms: ${verbForms.length}';
  }

  @override
  String displaySummary() {
    return 'Verb: ${plainVerb.displaySummary()}\nForms: ${verbForms.length}\n${super.displaySummary()}';
  }

  @override
  Future<void> add() async {
    LoggerService().d(
      'VerbVocab add: Saving plainVerb. Word: "${_plainVerbWordController.text}", Reading: "${_plainVerbReadingController.text}", Meaning: "${_plainVerbMeaningController.text}"',
    );
    plainVerb.verbWord = _plainVerbWordController.text;
    plainVerb.reading = _plainVerbReadingController.text;
    plainVerb.meaning = _plainVerbMeaningController.text;
    // TODO: Implement saving logic for verbForms if they are made editable.
    // This might involve parsing new/updated forms from controllers.
    await super.addToBox();
    LoggerService().i('VerbVocab add: Added to box.');
  }

  @override
  Future<void> save() async {
    LoggerService().d(
      'VerbVocab save: Saving plainVerb. Word: "${_plainVerbWordController.text}", Reading: "${_plainVerbReadingController.text}", Meaning: "${_plainVerbMeaningController.text}"',
    );
    plainVerb.verbWord = _plainVerbWordController.text;
    plainVerb.reading = _plainVerbReadingController.text;
    plainVerb.meaning = _plainVerbMeaningController.text;
    // TODO: Implement saving logic for verbForms if they are made editable.
    // This might involve parsing new/updated forms from controllers.
    await super.save();
    LoggerService().i('VerbVocab save: Save complete.');
  }

  @override
  String toString() {
    return 'VerbVocab{plainVerb: $plainVerb, verbForms: $verbForms, type: $type, '
        'level: $level, nextReview: $nextReview}';
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
    return {
      'type': type.name,
      'level': level,
      'nextReview': nextReview.toIso8601String(),
      'plainVerb': plainVerb.toJson(),
      // Assumes VerbForm has toJson()
      'verbForms': verbForms.map((key, value) => MapEntry(key, value.toJson())),
      // Assumes VerbForm has toJson()
    };
  }

  factory VerbVocab.fromJson(Map<String, dynamic> json) {
    LoggerService().d(
      'VerbVocab fromJson: Attempting to create VerbVocab from JSON: $json',
    );
    if (json['type'] != VocabType.verb.name) {
      LoggerService().e(
        'VerbVocab fromJson: Invalid type for VerbVocab.fromJson. Expected ${VocabType.verb.name}, got ${json['type']}',
      );
      throw ArgumentError(
        'Invalid type for VerbVocab.fromJson: ${json['type']}',
      );
    }

    final vocab = VerbVocab(
      plainVerb: VerbForm.fromJson(json['plainVerb'] as Map<String, dynamic>),
      verbForms:
          (json['verbForms'] as Map<String, dynamic>?)?.map(
            (key, value) =>
                MapEntry(key, VerbForm.fromJson(value as Map<String, dynamic>)),
          ) ??
          {},
    );
    vocab.level = (json['level'] as int?) ?? 0;
    vocab.nextReview = json['nextReview'] != null
        ? DateTime.parse(json['nextReview'] as String)
        : DateTime.now();
    LoggerService().i(
      'VerbVocab fromJson: Successfully created VerbVocab: ${vocab.plainVerb.verbWord}',
    );
    return vocab;
  }
}
