part of 'vocab.dart';

class VerbVocab extends Vocab {
  VerbForm plainVerb;
  Map<String, VerbForm> verbForms; // Key is the form name e.g., "Past Polite"

  VerbVocab({
    super.id,
    required this.plainVerb,
    required this.verbForms,
    super.meta,
    super.notes,
  }) : super(type: VocabType.verb);

  @override
  Widget buildFormWidget({bool isNew = false}) {
    return VerbVocabForm(vocab: this, isNew: isNew);
  }

  @override
  Widget buildReviewWidget() {
    return VerbVocabReview(vocab: this);
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

  // @override
  // Future<void> add() async {
  //   // await super.addToBox();
  // }
  //
  // @override
  // Future<void> save() async {
  //   // await super.save();
  // }

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
    final typeStr = json['type'] as String?;
    if (typeStr != VocabType.verb.name) {
      final errorMsg =
          'VerbVocab.fromJson error: Invalid type. Expected ${VocabType.verb.name}, got $typeStr';
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
    return vocab;
  }
}
