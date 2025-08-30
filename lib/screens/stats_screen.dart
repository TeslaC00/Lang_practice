// lib/screens/stats_screen.dart
// ------------------------------
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/vocab.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Vocab>('vocabBox');
    final all = box.values.toList();
    final levelCounts = List<int>.generate(6, (_) => 0);
    for (final v in all) {
      levelCounts[v.level.clamp(0, 5)]++;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total items: ${all.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...List.generate(
              6,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(width: 72, child: Text('Level $i')),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: all.isEmpty ? 0 : levelCounts[i] / all.length,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${levelCounts[i]}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
