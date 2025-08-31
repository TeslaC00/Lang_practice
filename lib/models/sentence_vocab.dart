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
    _sentenceController = TextEditingController(text: sentence);
    _answerController = TextEditingController(text: answer);
    _reviewAnswerController = TextEditingController();
  }

  @override
  void dispose() {
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
    if (correctAnswer.trim().toLowerCase() == userAnswer) {
      feedbackSetter("Correct!");
      SRS.markCorrect(this);
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
      } else {
        feedbackSetter("Incorrect. Correct: $correctAnswer");
        SRS.markWrong(this);
      }
    }
  }

  @override
  List<Widget> buildFormFields(StateSetter setState) {
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
  Future<void> save() async {
    sentence = _sentenceController.text;
    answer = _answerController.text;
    await super.save();
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
    return {
      'type': type.name,
      'level': level,
      'nextReview': nextReview.toIso8601String(),
      'sentence': sentence,
      'answer': answer,
    };
  }

  factory SentenceVocab.fromJson(Map<String, dynamic> json) {
    if (json['type'] != VocabType.sentence.name) {
      throw ArgumentError(
        'Invalid type for SentenceVocab.fromJson: ${json['type']}',
      );
    }
    final vocab = SentenceVocab(
      sentence: json['sentence'] as String,
      answer: json['answer'] as String,
    );
    vocab.level = json['level'] as int;
    vocab.nextReview = DateTime.parse(json['nextReview'] as String);
    return vocab;
  }
}
