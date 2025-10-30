part of 'vocab.dart';

@HiveType(typeId: 2)
class WordVocab extends Vocab {
  @HiveField(3)
  String word;
  @HiveField(4)
  List<String> readings;
  @HiveField(5)
  List<String> meanings;

  WordVocab({
    required this.word,
    required this.readings,
    required this.meanings,
    super.meta,
    super.notes,
  }) : super(type: VocabType.word);

  @override
  Widget buildFormWidget({bool isNew = false}) {
    return WordVocabForm(vocab: this, isNew: isNew);
  }

  @override
  Widget buildReviewWidget() {
    return WordVocabReview(vocab: this);
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
    await super.addToBox();
  }

  @override
  Future<void> save() async {
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
