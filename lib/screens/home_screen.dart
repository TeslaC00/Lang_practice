// lib/screens/home_screen.dart
// ----------------------
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lang_practice/models/vocab.dart';
import 'package:lang_practice/screens/review_screen.dart';
import 'package:lang_practice/screens/stats_screen.dart';
import 'package:lang_practice/screens/vocab_list_screen.dart';
import 'package:lang_practice/services/data_io.dart';
import 'package:lang_practice/services/logger_service.dart';

import 'add_edit_vocab_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Vocab>('vocabBox');
    final dueCount = box.values
        .where((v) => v.nextReview.isBefore(DateTime.now()))
        .length;
    return Scaffold(
      appBar: AppBar(title: const Text('Japanese Trainer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Due Today', style: TextStyle(fontSize: 18)),
                    Text(
                      '$dueCount',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReviewScreen()),
              ),
              child: const Text('Start Review'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditVocabScreen()),
              ),
              child: const Text('Add Vocab / Grammar'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VocabListScreen()),
              ),
              child: const Text('Vocabulary List'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              ),
              child: const Text('Stats'),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async => await exportData(context),
                  child: Text("Export data"),
                ),
                ElevatedButton(
                  onPressed: () async => LoggerService().shareLogs(),
                  child: Text("Send Logs"),
                ),
                ElevatedButton(
                  onPressed: () async => await importData(context),
                  child: Text("Import data"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
