part of 'vocab.dart';

@HiveType(typeId: 4)
class SentenceVocab extends Vocab {
  @HiveField(4)
  String sentence;
  @HiveField(5)
  String answer;

  late TextEditingController _sentenceController;
  late TextEditingController _answerController;

  SentenceVocab({required this.sentence, required this.answer})
    : super(type: VocabType.sentence) {
    _sentenceController = TextEditingController(text: sentence);
    _answerController = TextEditingController(text: answer);
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
}
