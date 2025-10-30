part of 'vocab.dart';

class TimeVocab extends Vocab {
  String timeWord;
  List<String> readings;
  String timeString; // Stores a fixed time for HH:MM part.

  TimeVocab({
    super.id,
    required this.timeWord,
    required this.readings,
    required this.timeString,
    super.meta,
    super.notes,
  }) : super(type: VocabType.time);

  @override
  Widget buildFormWidget({bool isNew = false}) {
    return TimeVocabForm(vocab: this, isNew: isNew);
  }

  @override
  Widget buildReviewWidget() {
    return TimeVocabReview(vocab: this);
  }

  @override
  String displayTitle() {
    return timeWord;
  }

  @override
  String displaySubtext() {
    // This is specific to TimeVocab and doesn't use level/nextReview directly
    // It calls super.displaySubtext() in displaySummary()
    return '$readings at $timeString '
        '${notes.isNotEmpty ? '\nNotes: $notes' : ''}';
  }

  @override
  String displaySummary() {
    return 'Time: $timeWord ($readings) at $timeString\n${super.displaySummary()}';
  }

  // TODO: remove these functions
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
    // Relies on Vocab.toString() for meta details
    return 'TimeVocab{timeWord: $timeWord, reading: $readings, timeValue: $timeString, ${super.toString()}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is TimeVocab &&
          runtimeType == other.runtimeType &&
          timeWord == other.timeWord &&
          readings == other.readings &&
          timeString == other.timeString;

  @override
  int get hashCode =>
      super.hashCode ^
      timeWord.hashCode ^
      readings.hashCode ^
      timeString.hashCode;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson(); // Gets 'type', 'meta', and 'notes'
    json.addAll({
      'timeWord': timeWord,
      'readings': readings,
      'timeString': timeString,
    });
    return json;
  }

  static TimeVocab fromJson(Map<String, dynamic> json) {
    if (json['type'] != VocabType.time.name) {
      throw ArgumentError(
        'Invalid type for TimeVocab.fromJson: ${json['type']}',
      );
    }

    // Parse meta from json
    final metaJson = json['meta'] as Map<String, dynamic>?;
    final vocabMeta = metaJson != null
        ? VocabMeta.fromJson(metaJson)
        : VocabMeta(); // Default if not present

    final notes = json['notes'] as String? ?? ''; // Extract notes

    final vocab = TimeVocab(
      timeWord: json['timeWord'] as String,
      readings: List<String>.from(json['readings'] as List<dynamic>),
      timeString: json['timeString'] as String,
      meta: vocabMeta,
      notes: notes,
    );
    // Level and nextReview are now part of meta and handled by VocabMeta.fromJson
    // and Vocab constructor
    return vocab;
  }
}
