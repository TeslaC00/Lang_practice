// lib/screens/stats_screen.dart
// ------------------------------
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/vocab.dart';
import '../services/database.dart';

class LevelStat {
  final int level;
  final int count;

  LevelStat(this.level, this.count);
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase.instance; // Get DB instance
    // final box = Hive.box<Vocab>('vocabBox');
    // final all = box.values.toList();
    // final levelCounts = List<int>.generate(6, (_) => 0);
    // for (final v in all) {
    //   levelCounts[v.meta.level.clamp(0, 5)]++;
    // }
    final levelCol = db.vocabs.level;
    final countCol = db.vocabs.id.count();
    final query = db.selectOnly(db.vocabs)
      ..addColumns([levelCol, countCol])
      ..groupBy([levelCol]);

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: FutureBuilder<List<drift.TypedResult>>(
        future: query.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final results = snapshot.data!;
          int total = 0;
          final Map<int, int> levelCounts = {};
          for (final row in results) {
            final level = row.read(levelCol)!;
            final count = row.read(countCol)!;
            levelCounts[level] = count;
            total += count;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total items: $total',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...List.generate(6, (i) {
                  final count = levelCounts[i] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(width: 72, child: Text('Level $i')),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: total == 0 ? 0 : count / total,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('$count'),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
