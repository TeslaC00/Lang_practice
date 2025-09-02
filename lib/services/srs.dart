// lib/services/srs.dart
// ----------------------
import 'package:hive/hive.dart';
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
    v.meta.correctTimesCounter++;
    v.meta.totalCorrectTimes++;
    v.meta.lastReview = DateTime.now();
    v.meta.isNew = false;

    // TODO: update threshold
    if (v.meta.correctTimesCounter >= 3) {
      v.meta.level = (v.meta.level + 1).clamp(
        0,
        _levelIntervals.length - 1,
      ); // Fixed clamp upper bound
      v.meta.correctTimesCounter = 0;
      v.meta.wrongTimesCounter = 0;
    }

    v.meta.nextReview = DateTime.now().add(intervalForLevel(v.meta.level));
    v.save();
  }

  static void markWrong(Vocab v) {
    v.meta.wrongTimesCounter++;
    v.meta.totalWrongTimes++;
    v.meta.lastReview = DateTime.now();
    v.meta.isNew = false;

    // TODO: update to threshold & softThreshold
    if (v.meta.wrongTimesCounter >= 5 || v.meta.wrongTimesCounter == 1) {
      v.meta.level = (v.meta.level - 1).clamp(
        0,
        _levelIntervals.length - 1,
      ); // Fixed clamp upper bound
      v.meta.wrongTimesCounter = 0;
      v.meta.correctTimesCounter = 0;
    }

    v.meta.nextReview = DateTime.now().add(
      const Duration(hours: 6),
    ); // quick comeback after a miss
    v.save();
  }

  static Future<List<Vocab>> getDues({int maxReviewPerDay = 30}) async {
    final box = Hive.box<Vocab>('vocabBox');
    final now = DateTime.now();
    final result = <Vocab>[];
    final highLevel = <Vocab>[];
    final oldLevel0 = <Vocab>[];
    final newLevel0 = <Vocab>[];

    for (final vocab in box.values) {
      if (vocab.meta.nextReview.isAfter(now)) continue;

      if (vocab.meta.level > 0) {
        highLevel.add(vocab);
      } else if (vocab.meta.isNew) {
        newLevel0.add(vocab);
      } else {
        oldLevel0.add(vocab);
      }
    }

    if (highLevel.length >= maxReviewPerDay) {
      return highLevel.sublist(0, maxReviewPerDay);
    }

    result.addAll(highLevel);

    if (result.length < maxReviewPerDay) {
      result.addAll(oldLevel0.take(maxReviewPerDay - result.length));
    }

    if (result.length < maxReviewPerDay) {
      result.addAll(newLevel0.take(maxReviewPerDay - result.length));
    }

    return result;
  }

  static Future<int> getDueCont({int maxReviewPerDay = 30}) async {
    final dues = await SRS.getDues(maxReviewPerDay: maxReviewPerDay);
    return dues.length;
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
