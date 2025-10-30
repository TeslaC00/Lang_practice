part of 'vocab.dart';

@HiveType(typeId: 4)
class SentenceVocab extends Vocab {
  @HiveField(3)
  String sentence;
  @HiveField(4)
  String answer;

  SentenceVocab({
    required this.sentence,
    required this.answer,
    super.meta,
    super.notes,
  }) : super(type: VocabType.sentence);

  @override
  Widget buildFormWidget({bool isNew = false}) {
    return SentenceVocabForm(vocab: this, isNew: isNew);
  }

  @override
  Widget buildReviewWidget() {
    return SentenceVocabReview(vocab: this);
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
    // This will save the Vocab object including its meta field
    await super.addToBox();
  }

  @override
  Future<void> save() async {
    // This will save the Vocab object including its meta field
    await super.save();
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
    final json = super.toJson(); // Gets type, notes and meta
    json.addAll({'sentence': sentence, 'answer': answer});
    return json;
  }

  static SentenceVocab fromJson(Map<String, dynamic> json) {
    if (json['type'] != VocabType.sentence.name) {
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
    return vocab;
  }
}
