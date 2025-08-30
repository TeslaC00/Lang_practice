// lib/screens/review_screen.dart
// -------------------------------
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/vocab.dart';
import '../services/srs.dart';

enum ExerciseType {
  kanjiReading,
  kanjiMeaning,
  engToJp,
  grammarGap,
  verbConj,
  timeReading,
}

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _box = Hive.box<Vocab>('vocabBox');
  final _answer = TextEditingController();
  Vocab? _current;
  ExerciseType? _currentEx;
  String _question = '';
  String _feedback = '';
  bool _revealed = false;

  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _nextCard();
  }

  void _nextCard() {
    final due = _box.values
        .where((v) => v.nextReview.isBefore(DateTime.now()))
        .toList();
    if (due.isEmpty) {
      setState(() {
        _current = null;
        _question = '';
        _currentEx = null;
      });
      return;
    }
    due.shuffle(_rng);
    final v = due.first;

    final ex = _pickExerciseFor(v);
    final q = _buildQuestion(v, ex);

    setState(() {
      _current = v;
      _currentEx = ex;
      _question = q;
      _answer.clear();
      _feedback = '';
      _revealed = false;
    });
  }

  ExerciseType _pickExerciseFor(Vocab v) {
    switch (v.type) {
      case VocabType.word:
        return _rng.nextBool()
            ? ExerciseType.kanjiReading
            : ExerciseType.kanjiMeaning;
      case VocabType.verb:
        return ExerciseType.verbConj;
      case VocabType.grammar:
        return ExerciseType.grammarGap;
      case VocabType.time:
        return ExerciseType.timeReading;
    }
  }

  String _buildQuestion(Vocab v, ExerciseType ex) {
    switch (ex) {
      case ExerciseType.kanjiReading:
        return 'Reading for: ${v.prompt}';
      case ExerciseType.kanjiMeaning:
        return 'Meaning of: ${v.prompt}';
      case ExerciseType.engToJp:
        return 'Japanese for: ${v.meanings.isNotEmpty ? v.meanings.first : v.prompt}';
      case ExerciseType.grammarGap:
        final s = v.example ?? '___ を ください';
        return 'Fill the blank:\n$s';
      case ExerciseType.verbConj:
        return 'Conjugate "${v.prompt}" to the target form (e.g., negative, past, negative past).';
      case ExerciseType.timeReading:
        return 'How do you say this time: ${v.prompt}';
    }
  }

  List<String> _correctAnswers(Vocab v, ExerciseType ex) {
    final extras = v.extraAccept ?? const [];
    switch (ex) {
      case ExerciseType.kanjiReading:
        return [...v.readings, ...extras];
      case ExerciseType.kanjiMeaning:
        return [...v.meanings, ...extras];
      case ExerciseType.engToJp:
        return [...v.readings, ...extras];
      case ExerciseType.grammarGap:
        // Expect the missing token(s) as answer, supply via readings or extraAccept.
        return [...v.readings, ...extras];
      case ExerciseType.verbConj:
        // Put target form(s) into readings or extraAccept when creating the card.
        return [...v.readings, ...extras];
      case ExerciseType.timeReading:
        // e.g., 7:30 -> ["しちじはん", "七時半", "7時半"]
        return [...v.readings, ...extras];
    }
  }

  void _submit() {
    if (_current == null || _currentEx == null) return;
    final answers = _correctAnswers(_current!, _currentEx!);
    final ok = answerMatches(_answer.text, answers);
    setState(() {
      _revealed = true;
      if (ok) {
        _feedback = '✅ Correct!';
        SRS.markCorrect(_current!);
      } else {
        _feedback = '❌ Wrong. Accepted: ${answers.join(', ')}';
        SRS.markWrong(_current!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_current == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No cards due right now.'),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _nextCard,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Review')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_question, style: theme.textTheme.titleLarge),
                    if (_currentEx == ExerciseType.grammarGap &&
                        _current!.grammarNote != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Hint: ${_current!.grammarNote!}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _answer,
              decoration: const InputDecoration(
                labelText: 'Your answer',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _submit, child: const Text('Check')),
            const SizedBox(height: 12),
            if (_revealed) Text(_feedback),
            const Spacer(),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Skip without grading: gently postpone a bit
                    _current!
                      ..nextReview = DateTime.now().add(
                        const Duration(hours: 12),
                      )
                      ..save();
                    _nextCard();
                  },
                  child: const Text('Skip'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () {
                    _nextCard();
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
