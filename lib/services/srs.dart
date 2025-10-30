// lib/services/srs.dart
// ----------------------
import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:lang_practice/models/vocab.dart';
import 'package:lang_practice/vocab_mapper.dart';

import 'database.dart';

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
    //  Business logic
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

    // 2. Save to Drift DB
    final db = AppDatabase.instance;
    await db.update(db.vocabs).replace(VocabMapper.vocabToCompanion(v));

    // 3. Remove from today's Drift cache
    await (db.delete(
      db.dailyDueCache,
    )..where((tbl) => tbl.vocabId.equals(v.id!))).go();

    // 4. Update count from Drift cache
    final countQuery = db.selectOnly(db.dailyDueCache)
      ..addColumns([db.dailyDueCache.vocabId.count()]);
    final count =
        (await countQuery.getSingle()).read(db.dailyDueCache.vocabId.count()) ??
        0;
    dueCount.value = count;
    // await v.save();

    // Remove from today's cache
    // final cache = Hive.box<dynamic>('cacheBox');
    // await cache.delete(v.id);
    // dueCount.value = cache.values.whereType<int>().length;
  }

  static Future<void> markWrong(Vocab v) async {
    // v.dispose();
    // Business logic
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
    // await v.save();

    // 2. Save to Drift DB
    final db = AppDatabase.instance;
    await db.update(db.vocabs).replace(VocabMapper.vocabToCompanion(v));

    // 3. Remove from today's Drift cache
    await (db.delete(
      db.dailyDueCache,
    )..where((tbl) => tbl.vocabId.equals(v.id!))).go();

    // 4. Update count from Drift cache
    final countQuery = db.selectOnly(db.dailyDueCache)
      ..addColumns([db.dailyDueCache.vocabId.count()]);
    final count =
        (await countQuery.getSingle()).read(db.dailyDueCache.vocabId.count()) ??
        0;
    dueCount.value = count;

    // Remove from today's cache
    // final cache = Hive.box<dynamic>('cacheBox');
    // await cache.delete(v.id);
    // dueCount.value = cache.values.whereType<int>().length;
  }

  static Future<void> getDailyDues({int maxReviewPerDay = 30}) async {
    final now = DateTime.now();
    // final box = Hive.box<Vocab>('vocabBox');
    // final cache = Hive.box<dynamic>('cacheBox');
    final db = AppDatabase.instance; // Get DB instance
    final todayKey = "${now.year}-${now.month}-${now.day}";

    // final lastDate = cache.get('lastDate') as String?;
    // final todayKey = "${now.year}-${now.month}-${now.day}";

    // Check lastDate from our new KeyValueStore
    final dateEntry = await (db.select(
      db.keyValueStore,
    )..where((tbl) => tbl.key.equals('lastDate'))).getSingleOrNull();
    final lastDate = dateEntry?.value;

    if (lastDate == todayKey) {
      // dueCount.value = cache.values.whereType<int>().length;
      // Already initialized, just get count
      final countQuery = db.selectOnly(db.dailyDueCache)
        ..addColumns([db.dailyDueCache.vocabId.count()]);
      final count =
          (await countQuery.getSingle()).read(
            db.dailyDueCache.vocabId.count(),
          ) ??
          0;
      dueCount.value = count;
      return;
    }

    // Regenerate dues
    // await cache.clear();
    await db.delete(db.dailyDueCache).go(); // Clear old cache

    // This is the magic: Get all due items with ONE query
    final query = db.select(db.vocabs)
      ..where((tbl) => tbl.nextReview.isSmallerOrEqual(drift.Constant(now)));

    final allDueEntries = await query.get();

    // Convert Drift entries to Vocab models
    final allDueVocabs = allDueEntries
        .map((entry) => VocabMapper.entryToVocab(entry))
        .toList();

    final result = <Vocab>[];
    final highLevel = <Vocab>[];
    final oldLevel0 = <Vocab>[];
    final newLevel0 = <Vocab>[];

    for (final vocab in allDueVocabs) {
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

    // Save new cache list to Drift
    final cacheCompanions = result.map(
      (v) => DailyDueCacheCompanion.insert(vocabId: drift.Value(v.id!)),
    );
    await db.batch((batch) {
      batch.insertAll(db.dailyDueCache, cacheCompanions);
    });

    // Save new date
    await db
        .into(db.keyValueStore)
        .insert(
          KeyValueStoreCompanion.insert(key: 'lastDate', value: todayKey),
          mode: drift.InsertMode.replace,
        );

    dueCount.value = result.length;

    // for (final v in result) {
    //   await cache.put(v.id as int, v.id as int);
    // }
    // await cache.put('lastDate', todayKey);
    //
    // dueCount.value = result.length;
  }

  static Future<List<Vocab>> getDues({int maxReviewPerDay = 30}) async {
    await getDailyDues(maxReviewPerDay: maxReviewPerDay);

    // final box = Hive.box<Vocab>('vocabBox');
    // final cache = Hive.box<dynamic>('cacheBox');
    //
    // final ids = cache.values.whereType<int>().toList();
    // return ids.map((id) => box.get(id)!).toList();

    final db = AppDatabase.instance;

    // Get all IDs from the cache
    final idEntries = await db.select(db.dailyDueCache).get();
    final ids = idEntries.map((e) => e.vocabId).toList();

    if (ids.isEmpty) return [];

    // Get all vocab entries for those IDs
    final entries = await (db.select(
      db.vocabs,
    )..where((tbl) => tbl.id.isIn(ids))).get();

    // Convert Drift entries to Vocab models and return
    return entries.map((entry) => VocabMapper.entryToVocab(entry)).toList();
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
