// lib/screens/review_screen.dart
// -------------------------------
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/vocab.dart';
import '../services/srs.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late List<Vocab> due;
  int index = 0;
  Vocab? _current;

  final _rng = Random();

  @override
  void initState() {
    super.initState();
    index = 0;
    _loadDues();
  }

  Future<void> _loadDues() async {
    final result = await SRS.getDues();

    if (!mounted) return; // safeguard if widget is disposed

    setState(() {
      due = result;
      if (due.isEmpty) {
        _current = null;
      } else {
        due.shuffle(_rng);
        _nextQuestion(); // no need for await here
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _current = (index >= due.length) ? null : due[index++];
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _nextQuestion,
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
            ..._current!.buildReviewFields(setState),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: _nextQuestion,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
