part of 'vocab.dart';

@HiveType(typeId: 3)
class TimeVocab extends Vocab {
  @HiveField(4)
  String timeWord;
  @HiveField(5)
  String reading;
  @HiveField(6)
  String timeString; // Stores a fixed time for HH:MM part.

  late TextEditingController _timeWordController;
  late TextEditingController _readingController;
  late TextEditingController _timeValueController; // For form input

  late TextEditingController _readingAnswerController;
  late TextEditingController _timeValueAnswerController; // For review input

  String _readingFeedback = '';
  String _timeValueFeedback = '';

  TimeVocab({
    required this.timeWord,
    required this.reading,
    required this.timeString,
  }) : super(type: VocabType.time) {
    LoggerService().d(
      'TimeVocab created: $timeWord, reading: $reading, time: $timeString',
    );
    _timeWordController = TextEditingController(text: timeWord);
    _readingController = TextEditingController(text: reading);
    _timeValueController = TextEditingController(text: timeString);
    _readingAnswerController = TextEditingController();
    _timeValueAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    LoggerService().d('Disposing TimeVocab: $timeWord');
    _timeWordController.dispose();
    _readingController.dispose();
    _timeValueController.dispose();
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
          'Reading answer incorrect for "$timeWord". User: "$userAnswer", '
          'Correct: "${correctAnswers.join(', ')}"',
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
      LoggerService().i('Time answer correct for "$timeWord"');
    } else {
      feedbackSetter("Incorrect. Correct: $correctTimeString");
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
          [reading], // reading is a single string
          (f) => setState(() => _readingFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitAnswerLogic(_readingAnswerController, [
          reading,
        ], (f) => setState(() => _readingFeedback = f)),
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
    return '$reading at $timeString';
  }

  @override
  String displaySummary() {
    return 'Time: $timeWord ($reading) at $timeString\n${super.displaySummary()}';
  }

  @override
  Future<void> add() async {
    LoggerService().d(
      'Adding TimeVocab. Current: $timeWord, New word: ${_timeWordController.text}, New reading: ${_readingController.text}, New time: ${_timeValueController.text}',
    );
    timeWord = _timeWordController.text;
    reading = _readingController.text;
    timeString = _timeValueController.text;
    await super.addToBox();
    LoggerService().i('TimeVocab "$timeWord" added.');
  }

  @override
  Future<void> save() async {
    LoggerService().d(
      'Saving TimeVocab. Current: $timeWord, New word: ${_timeWordController.text}, New reading: ${_readingController.text}, New time: ${_timeValueController.text}',
    );
    timeWord = _timeWordController.text;
    reading = _readingController.text;
    timeString = _timeValueController.text;
    await super.save();
    LoggerService().i('TimeVocab "$timeWord" saved.');
  }

  @override
  String toString() {
    return 'TimeVocab{timeWord: $timeWord, reading: $reading, '
        'timeValue: $timeString, type: $type, level: $level, nextReview: $nextReview}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is TimeVocab &&
          runtimeType == other.runtimeType &&
          timeWord == other.timeWord &&
          reading == other.reading &&
          timeString == other.timeString;

  @override
  int get hashCode =>
      super.hashCode ^
      timeWord.hashCode ^
      reading.hashCode ^
      timeString.hashCode;

  @override
  Map<String, dynamic> toJson() {
    LoggerService().d('Converting TimeVocab to JSON: $timeWord');
    return {
      'type': type.name,
      'level': level,
      'nextReview': nextReview.toIso8601String(),
      'timeWord': timeWord,
      'reading': reading,
      'timeString': timeString, // Store as HH:mm string
    };
  }

  factory TimeVocab.fromJson(Map<String, dynamic> json) {
    LoggerService().d(
      'Attempting to create TimeVocab from JSON: ${json['timeWord']}',
    );
    if (json['type'] != VocabType.time.name) {
      LoggerService().e('Invalid type for TimeVocab.fromJson: ${json['type']}');
      throw ArgumentError(
        'Invalid type for TimeVocab.fromJson: ${json['type']}',
      );
    }
    final vocab = TimeVocab(
      timeWord: json['timeWord'] as String,
      reading: json['reading'] as String,
      timeString: json['timeString'] as String, // Parse from HH:mm string
    );
    vocab.level = (json['level'] as int?) ?? 0;
    vocab.nextReview = json['nextReview'] != null
        ? DateTime.parse(json['nextReview'] as String)
        : DateTime.now();
    LoggerService().i('TimeVocab created from JSON: ${vocab.timeWord}');
    return vocab;
  }
}
