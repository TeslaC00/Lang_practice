// lib/services/srs.dart
// ----------------------
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:lang_practice/models/vocab.dart';

class SRS {
  // reactive count - UI
  static final ValueNotifier<int> dueCount = ValueNotifier(0);

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
  static Future<void> markCorrect(Vocab v) async {
    v.dispose();
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
    await v.save();

    // Remove from today's cache
    final cache = Hive.box<dynamic>('cacheBox');
    await cache.delete(v.key);
    dueCount.value = cache.values.whereType<int>().length;
  }

  static Future<void> markWrong(Vocab v) async {
    v.dispose();
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
    await v.save();

    // Remove from today's cache
    final cache = Hive.box<dynamic>('cacheBox');
    await cache.delete(v.key);
    dueCount.value = cache.values.whereType<int>().length;
  }

  static Future<void> getDailyDues({int maxReviewPerDay = 30}) async {
    final now = DateTime.now();
    final box = Hive.box<Vocab>('vocabBox');
    final cache = Hive.box<dynamic>('cacheBox');

    final lastDate = cache.get('lastDate') as String?;
    final todayKey = "${now.year}-${now.month}-${now.day}";

    if (lastDate == todayKey) {
      dueCount.value = cache.values.whereType<int>().length;
      return; // already initialized
    }

    // Regenerate dues
    await cache.clear();

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
      result.addAll(highLevel.sublist(0, maxReviewPerDay));
    } else {
      result.addAll(highLevel);
      if (result.length < maxReviewPerDay) {
        result.addAll(oldLevel0.take(maxReviewPerDay - result.length));
      }
      if (result.length < maxReviewPerDay) {
        result.addAll(newLevel0.take(maxReviewPerDay - result.length));
      }
    }

    for (final v in result) {
      await cache.put(v.key as int, v.key as int);
    }
    await cache.put('lastDate', todayKey);

    dueCount.value = result.length;
  }

  static Future<List<Vocab>> getDues({int maxReviewPerDay = 30}) async {
    await getDailyDues(maxReviewPerDay: maxReviewPerDay);

    final box = Hive.box<Vocab>('vocabBox');
    final cache = Hive.box<dynamic>('cacheBox');

    final ids = cache.values.whereType<int>().toList();
    return ids.map((id) => box.get(id)!).toList();
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
