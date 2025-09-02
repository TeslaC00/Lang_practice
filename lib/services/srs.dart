// lib/services/srs.dart
// ----------------------
import 'package:lang_practice/models/vocab.dart';

class SRS {
  // Simple intervals tuned for once-a-day usage.
  static const List<Duration> _levelIntervals = <Duration>[
    Duration(hours: 0), // L0 - due immediately
    Duration(days: 1), // L1 - 1 day
    Duration(days: 2), // L2 - 2 day
    Duration(days: 4), // L3 - 4 day
    Duration(days: 7), // L4 - 1 week
    Duration(days: 10), // L5 - 10 day
    Duration(days: 14), // L6 - 2 week
    Duration(days: 20), // L7 - 20 day
    Duration(days: 25), // L8 - 25 day
    Duration(days: 30), // L9 - 1 month
    Duration(days: 45), // L10 - 45 day
  ];

  static Duration intervalForLevel(int level) {
    final idx = level.clamp(0, _levelIntervals.length - 1);
    return _levelIntervals[idx];
  }

  // Don't increase vocab level for each correct answer
  static void markCorrect(Vocab v) {
    v.meta.level = (v.meta.level + 1).clamp(0, _levelIntervals.length -1); // Fixed clamp upper bound
    v.meta.nextReview = DateTime.now().add(intervalForLevel(v.meta.level));
    v.meta.lastReview = DateTime.now();
    v.meta.totalCorrectTimes++;
    v.meta.correctTimesCounter++;
    v.meta.wrongTimesCounter = 0;
    v.meta.isNew = false;
    v.save();
  }

  static void markWrong(Vocab v) {
    v.meta.level = (v.meta.level - 1).clamp(0, _levelIntervals.length -1); // Fixed clamp upper bound
    // quick comeback after a miss
    v.meta.nextReview = DateTime.now().add(const Duration(hours: 6));
    v.meta.lastReview = DateTime.now();
    v.meta.totalWrongTimes++;
    v.meta.wrongTimesCounter++;
    v.meta.correctTimesCounter = 0;
    v.meta.isNew = false;
    v.save();
  }
}

bool answerMatches(String input, List<String> answers) {
  final norm = _norm(input);
  for (final a in answers) {
    if (_norm(a) == norm) return true;
  }
  return false;
}

String _norm(String s) => s.trim().toLowerCase();
