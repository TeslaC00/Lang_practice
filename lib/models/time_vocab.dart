part of 'vocab.dart';

@HiveType(typeId: 3)
class TimeVocab extends Vocab {
  @HiveField(4)
  String timeWord;
  @HiveField(5)
  String reading;
  @HiveField(6)
  TimeOfDay timeValue; // Stores a fixed time for HH:MM part.

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
    required this.timeValue,
  }) : super(type: VocabType.time) {
    _timeWordController = TextEditingController(text: timeWord);
    _readingController = TextEditingController(text: reading);
    _timeValueController = TextEditingController(
      text: _formatTimeOfDay(timeValue),
    );
    _readingAnswerController = TextEditingController();
    _timeValueAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    _timeWordController.dispose();
    _readingController.dispose();
    _timeValueController.dispose();
    _readingAnswerController.dispose();
    _timeValueAnswerController.dispose();
    // if Vocab has a dispose, call super.dispose();
  }

  static String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hour.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static TimeOfDay _parseTimeOfDay(String formattedString) {
    try {
      final parts = formattedString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing TimeOfDay string "$formattedString": $e');
      }
    }
    // Return a default or throw an error
    return const TimeOfDay(hour: 0, minute: 0); // Default fallback
  }

  // Helper method for review logic (adapted from WordVocab)
  void _submitAnswerLogic(
    TextEditingController controller,
    List<String> correctAnswers,
    Function(String) feedbackSetter,
  ) {
    final userAnswer = controller.text.trim().toLowerCase();
    if (correctAnswers.any((ans) => ans.trim().toLowerCase() == userAnswer)) {
      feedbackSetter("Correct!");
      SRS.markCorrect(this);
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
      } else {
        feedbackSetter("Incorrect. Correct: ${correctAnswers.join(', ')}");
        SRS.markWrong(this);
      }
    }
  }

  void _submitTimeAnswerLogic(
    TextEditingController controller,
    TimeOfDay correctTimeValue,
    Function(String) feedbackSetter,
  ) {
    final userAnswerString = controller.text.trim();
    try {
      final userAnswerTime = _parseTimeOfDay(userAnswerString);
      if (userAnswerTime.hour == correctTimeValue.hour &&
          userAnswerTime.minute == correctTimeValue.minute) {
        feedbackSetter("Correct!");
      } else {
        feedbackSetter(
          "Incorrect. Correct: ${_formatTimeOfDay(correctTimeValue)}",
        );
      }
    } catch (e) {
      feedbackSetter("Invalid format. Please use HH:MM.");
    }
  }

  @override
  List<Widget> buildFormFields(StateSetter setState) {
    return [
      _LabeledField('Time Word (e.g., 7:30 AM)', _timeWordController),
      const SizedBox(height: 10),
      _LabeledField('Reading (e.g., しちじはん)', _readingController),
      const SizedBox(height: 10),
      _LabeledField('Time Value (HH:mm e.g., 07:30)', _timeValueController),
      const SizedBox(height: 10),
    ];
  }

  @override
  List<Widget> buildReviewFields(StateSetter setState) {
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
          timeValue,
          (f) => setState(() => _timeValueFeedback = f),
        ),
      ),
      const SizedBox(height: 5),
      FilledButton(
        onPressed: () => _submitTimeAnswerLogic(
          _timeValueAnswerController,
          timeValue,
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
    String formattedTime = _formatTimeOfDay(_currentTimeOfDay);
    return '$reading at $formattedTime';
  }

  @override
  String displaySummary() {
    String formattedTime = _formatTimeOfDay(_currentTimeOfDay);
    return 'Time: $timeWord ($reading) at $formattedTime\n${super.displaySummary()}';
  }

  @override
  Future<void> save() async {
    timeWord = _timeWordController.text;
    reading = _readingController.text;
    try {
      timeValue = _parseTimeOfDay(_timeValueController.text);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing timeValue from controller: $e');
      }
      // Optionally handle error, e.g., by not changing timeValue
    }
    await super.save();
  }

  @override
  String toString() {
    return 'TimeVocab{timeWord: $timeWord, reading: $reading, '
        'timeValue: ${_formatTimeOfDay(_currentTimeOfDay)}, type: $type, level: $level, nextReview: $nextReview}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is TimeVocab &&
          runtimeType == other.runtimeType &&
          timeWord == other.timeWord &&
          reading == other.reading &&
          // Compare hour and minute for TimeOfDay equivalence
          timeValue.hour == other.timeValue.hour &&
          timeValue.minute == other.timeValue.minute;

  @override
  int get hashCode =>
      super.hashCode ^
      timeWord.hashCode ^
      reading.hashCode ^
      timeValue.hour.hashCode ^
      timeValue.minute.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'level': level,
      'nextReview': nextReview.toIso8601String(),
      'timeWord': timeWord,
      'reading': reading,
      'timeValue': _formatTimeOfDay(timeValue), // Store as HH:mm string
    };
  }

  factory TimeVocab.fromJson(Map<String, dynamic> json) {
    if (json['type'] != VocabType.time.name) {
      throw ArgumentError(
        'Invalid type for TimeVocab.fromJson: ${json['type']}',
      );
    }
    final vocab = TimeVocab(
      timeWord: json['timeWord'] as String,
      reading: json['reading'] as String,
      timeValue: _parseTimeOfDay(
        json['timeValue'] as String,
      ), // Parse from HH:mm string
    );
    vocab.level = json['level'] as int;
    vocab.nextReview = DateTime.parse(json['nextReview'] as String);
    return vocab;
  }
}
