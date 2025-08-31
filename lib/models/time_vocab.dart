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
  late TextEditingController _timeValueController;

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

  TimeOfDay get _currentTimeOfDay =>
      TimeOfDay(hour: timeValue.hour, minute: timeValue.minute);

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
}
