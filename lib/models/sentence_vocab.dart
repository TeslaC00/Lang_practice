part of 'vocab.dart';

@HiveType(typeId: 4)
class SentenceVocab extends Vocab {
  @HiveField(4)
  String sentence;
  @HiveField(5)
  String answer;

  late TextEditingController _sentenceController;
  late TextEditingController _answerController;
  late TextEditingController _reviewAnswerController; // For review input

  String _reviewFeedback = ''; // Feedback for the review screen

  SentenceVocab({required this.sentence, required this.answer})
    : super(type: VocabType.sentence) {
    LoggerService().d('SentenceVocab created: "$sentence" - "$answer"');
    _sentenceController = TextEditingController(text: sentence);
    _answerController = TextEditingController(text: answer);
    _reviewAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    LoggerService().d('SentenceVocab.dispose called for "$sentence"');
    _sentenceController.dispose();
    _answerController.dispose();
    _reviewAnswerController.dispose();
    // if Vocab has a dispose, call super.dispose();
  }

  // Helper method for review logic (adapted from WordVocab)
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
      SRS.markCorrect(this);
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
        LoggerService().w('SentenceVocab review: Empty answer for "$sentence"');
      } else {
        feedbackSetter("Incorrect. Correct: $correctAnswer");
        LoggerService().w(
          'SentenceVocab review: Incorrect for "$sentence". User: "$userAnswer", Correct: "$correctAnswer"',
        );
        SRS.markWrong(this);
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
    ];
  }

  @override
  List<Widget> buildReviewFields(StateSetter setState) {
    LoggerService().d('SentenceVocab.buildReviewFields called for "$sentence"');
    // Show the sentence and ask for answer
    return [
      Text(
        sentence, // Display the sentence (question)
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          answer, // The correct answer
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

  @override
  String displaySubtext() {
    return answer;
  }

  @override
  String displaySummary() {
    return 'Sentence: "$sentence"\nAnswer: "$answer"\n${super.displaySummary()}';
  }

  @override
  Future<void> add() async {
    LoggerService().d(
      'SentenceVocab.add called. Old: "$sentence" - "$answer". New: "${_sentenceController.text}" - "${_answerController.text}"',
    );
    sentence = _sentenceController.text;
    answer = _answerController.text;
    await super.addToBox();
    LoggerService().i('SentenceVocab added: "$sentence"');
  }

  @override
  Future<void> save() async {
    LoggerService().d(
      'SentenceVocab.save called. Old: "$sentence" - "$answer". New: "${_sentenceController.text}" - "${_answerController.text}"',
    );
    sentence = _sentenceController.text;
    answer = _answerController.text;
    await super.save();
    LoggerService().i('SentenceVocab saved: "$sentence"');
  }

  @override
  String toString() {
    return 'SentenceVocab{sentence: $sentence, answer: $answer, type: $type, '
        'level: $level, nextReview: $nextReview}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is SentenceVocab &&
          runtimeType == other.runtimeType &&
          sentence == other.sentence &&
          answer == other.answer;

  @override
  int get hashCode => super.hashCode ^ sentence.hashCode ^ answer.hashCode;

  @override
  Map<String, dynamic> toJson() {
    LoggerService().d('SentenceVocab.toJson called for "$sentence"');
    return {
      'type': type.name,
      'level': level,
      'nextReview': nextReview.toIso8601String(),
      'sentence': sentence,
      'answer': answer,
    };
  }

  factory SentenceVocab.fromJson(Map<String, dynamic> json) {
    LoggerService().d('SentenceVocab.fromJson called with data: $json');
    if (json['type'] != VocabType.sentence.name) {
      LoggerService().e(
        'Invalid type for SentenceVocab.fromJson: ${json['type']}. Expected ${VocabType.sentence.name}',
      );
      throw ArgumentError(
        'Invalid type for SentenceVocab.fromJson: ${json['type']}',
      );
    }
    final vocab = SentenceVocab(
      sentence: json['sentence'] as String,
      answer: json['answer'] as String,
    );
    vocab.level = (json['level'] as int?) ?? 0;
    vocab.nextReview = json['nextReview'] != null
        ? DateTime.parse(json['nextReview'] as String)
        : DateTime.now();
    LoggerService().i('SentenceVocab created from JSON: "${vocab.sentence}"');
    return vocab;
  }
}
