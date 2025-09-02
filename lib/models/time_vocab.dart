part of 'vocab.dart';

@HiveType(typeId: 3)
class TimeVocab extends Vocab {
  @HiveField(3)
  String timeWord;
  @HiveField(4)
  List<String> readings;
  @HiveField(5)
  String timeString; // Stores a fixed time for HH:MM part.

  late TextEditingController _timeWordController;
  late TextEditingController _readingController;
  late TextEditingController _timeValueController; // For form input
  late TextEditingController _notesController; // Added for notes

  late TextEditingController _readingAnswerController;
  late TextEditingController _timeValueAnswerController; // For review input

  String _readingFeedback = '';
  String _timeValueFeedback = '';

  TimeVocab({
    required this.timeWord,
    required this.readings,
    required this.timeString,
    super.meta,
    super.notes,
  }) : super(type: VocabType.time) {
    LoggerService().d(
      'TimeVocab created: $timeWord, reading: ${readings.join(', ')}, time: $timeString, meta: $meta',
    );
    _timeWordController = TextEditingController(text: timeWord);
    _readingController = TextEditingController(text: readings.join(', '));
    _timeValueController = TextEditingController(text: timeString);
    _notesController = TextEditingController(
      text: notes,
    ); // Initialize notes controller
    _readingAnswerController = TextEditingController();
    _timeValueAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    LoggerService().d('Disposing TimeVocab: $timeWord');
    _timeWordController.dispose();
    _readingController.dispose();
    _timeValueController.dispose();
    _notesController.dispose(); // Dispose notes controller
    _readingAnswerController.dispose();
    _timeValueAnswerController.dispose();
    // if Vocab has a dispose, call super.dispose();
  }

  // Helper method for review logic (adapted from WordVocab)
  void _submitAnswerLogic(
    TextEditingController controller,
    List<String> correctAnswers,
    Function(String) feedbackSetter,
  ) {
    final userAnswer = controller.text.trim().toLowerCase();
    LoggerService().d(
      'Submitting answer for reading. User: "$userAnswer", Correct: "${correctAnswers.join(', ')}"',
    );
    if (correctAnswers.any((ans) => ans.trim().toLowerCase() == userAnswer)) {
      feedbackSetter("Correct!");
      SRS.markCorrect(this);
      LoggerService().i('Reading answer correct for "$timeWord"');
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
        LoggerService().i('Reading answer empty for "$timeWord"');
      } else {
        feedbackSetter("Incorrect. Correct: ${correctAnswers.join(', ')}");
        SRS.markWrong(this);
        LoggerService().i(
          'Reading answer incorrect for "$timeWord". User: "$userAnswer", Correct: "${correctAnswers.join(', ')}"',
        );
      }
    }
  }

  void _submitTimeAnswerLogic(
    TextEditingController controller,
    String correctTimeString,
    Function(String) feedbackSetter,
  ) {
    final userAnswerString = controller.text.trim();
    LoggerService().d(
      'Submitting time answer. User: "$userAnswerString", Correct: $correctTimeString',
    );

    if (userAnswerString == correctTimeString) {
      feedbackSetter("Correct!");
      SRS.markCorrect(this); // Assuming marking correct for the whole item
      LoggerService().i('Time answer correct for "$timeWord"');
    } else {
      feedbackSetter("Incorrect. Correct: $correctTimeString");
      SRS.markWrong(this); // Assuming marking wrong for the whole item
      LoggerService().i(
        'Time answer incorrect for "$timeWord". User: "$userAnswerString", Correct: $correctTimeString',
      );
    }
  }

  @override
  List<Widget> buildFormFields(StateSetter setState) {
    LoggerService().d('Building form fields for TimeVocab: $timeWord');
    return [
      _LabeledField('Time Word (e.g., 7:30 AM, 今)', _timeWordController),
      const SizedBox(height: 10),
      _LabeledField('Reading (e.g., しちじはん, いま)', _readingController),
      const SizedBox(height: 10),
      _LabeledField('Time Value (HH:mm e.g., 07:30)', _timeValueController),
      const SizedBox(height: 10),
      _LabeledField('Notes', _notesController, maxLines: 3), // Added notes field
    ];
  }

  @override
  List<Widget> buildReviewFields(StateSetter setState) {
    LoggerService().d('Building review fields for TimeVocab: $timeWord');
    return [
      Text(
        timeWord,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      if (notes.isNotEmpty) // Display notes if they exist
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
          labelText: 'Give Reading',
          border: OutlineInputBorder(),
          hintText: 'Enter reading in hiragana/katakana',
        ),
        onSubmitted: (_) => _submitAnswerLogic(
          _readingAnswerController,
          readings, // reading is a single string
          (f) => setState(() => _readingFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitAnswerLogic(
          _readingAnswerController,
          readings,
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
        controller: _timeValueAnswerController,
        decoration: InputDecoration(
          labelText: 'Give Time (HH:MM)',
          border: OutlineInputBorder(),
          hintText: 'Enter time e.g., 07:30',
        ),
        keyboardType: TextInputType.datetime,
        onSubmitted: (_) => _submitTimeAnswerLogic(
          _timeValueAnswerController,
          timeString,
          (f) => setState(() => _timeValueFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitTimeAnswerLogic(
          _timeValueAnswerController,
          timeString,
          (f) => setState(() => _timeValueFeedback = f),
        ),
        child: const Text("Check Time Value"),
      ),
      const SizedBox(height: 5),
      if (_timeValueFeedback.isNotEmpty)
        Text(
          _timeValueFeedback,
          style: TextStyle(
            color: _timeValueFeedback == "Correct!" ? Colors.green : Colors.red,
          ),
        ),
    ];
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

  @override
  Future<void> add() async {
    LoggerService().d(
      'Adding TimeVocab. Current: $timeWord, New word: ${_timeWordController.text}, New reading: ${_readingController.text}, New time: ${_timeValueController.text}, New notes: ${_notesController.text}',
    );
    timeWord = _timeWordController.text;
    readings = _readingController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    timeString = _timeValueController.text;
    notes = _notesController.text; // Get notes from controller
    // meta is already part of the object, managed by Vocab class
    await super.addToBox();
    LoggerService().i('TimeVocab "$timeWord" added.');
  }

  @override
  Future<void> save() async {
    LoggerService().d(
      'Saving TimeVocab. Current: $timeWord, New word: ${_timeWordController.text}, New reading: ${_readingController.text}, New time: ${_timeValueController.text}, New notes: ${_notesController.text}',
    );
    timeWord = _timeWordController.text;
    readings = _readingController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    timeString = _timeValueController.text;
    notes = _notesController.text; // Get notes from controller
    // meta is already part of the object, managed by Vocab class
    await super.save();
    LoggerService().i('TimeVocab "$timeWord" saved.');
  }

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
    LoggerService().d('Converting TimeVocab to JSON: $timeWord');
    final json = super.toJson(); // Gets 'type', 'meta', and 'notes'
    json.addAll({
      'timeWord': timeWord,
      'readings': readings,
      'timeString': timeString,
    });
    return json;
  }

  static TimeVocab fromJson(Map<String, dynamic> json) {
    LoggerService().d(
      'Attempting to create TimeVocab from JSON: ${json['timeWord']}',
    );
    if (json['type'] != VocabType.time.name) {
      LoggerService().e('Invalid type for TimeVocab.fromJson: ${json['type']}');
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
    LoggerService().i('TimeVocab created from JSON: ${vocab.timeWord}');
    return vocab;
  }
}
