import 'package:flutter/material.dart';

import '../models/vocab.dart';
import '../services/srs.dart';

class TimeVocabReview extends StatefulWidget {
  final TimeVocab vocab;

  const TimeVocabReview({super.key, required this.vocab});

  @override
  State<StatefulWidget> createState() => _TimeVocabReviewState();
}

class _TimeVocabReviewState extends State<TimeVocabReview> {
  late TextEditingController _readingAnswerController;
  late TextEditingController _timeValueAnswerController; // For review input

  String _readingFeedback = '';
  String _timeValueFeedback = '';

  @override
  void initState() {
    super.initState();
    _readingAnswerController = TextEditingController();
    _timeValueAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    _readingAnswerController.dispose();
    _timeValueAnswerController.dispose();
    super.dispose();
  }

  void _submitAnswerLogic(
    TextEditingController controller,
    List<String> correctAnswers,
    Function(String) feedbackSetter,
  ) {
    final userAnswer = controller.text.trim().toLowerCase();
    if (correctAnswers.any((ans) => ans.trim().toLowerCase() == userAnswer)) {
      feedbackSetter("Correct!");
      SRS.markCorrect(widget.vocab);
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
      } else {
        feedbackSetter("Incorrect. Correct: ${correctAnswers.join(', ')}");
        SRS.markWrong(widget.vocab);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.vocab.timeWord,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (widget.vocab.notes.isNotEmpty) // Display notes if they exist
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Notes: ${widget.vocab.notes}",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        const SizedBox(height: 10),
        TextField(
          controller: _readingAnswerController,
          decoration: InputDecoration(
            labelText: 'Give Reading',
            border: OutlineInputBorder(),
            hintText: 'Enter reading in hiragana/katakana',
          ),
          onSubmitted: (_) => _submitAnswerLogic(
            _readingAnswerController,
            widget.vocab.readings, // reading is a single string
            (f) => setState(() => _readingFeedback = f),
          ),
        ),
        const SizedBox(height: 5),
        FilledButton(
          onPressed: () => _submitAnswerLogic(
            _readingAnswerController,
            widget.vocab.readings,
            (f) => setState(() => _readingFeedback = f),
          ),
          child: const Text("Check Reading"),
        ),
        const SizedBox(height: 5),
        if (_readingFeedback.isNotEmpty)
          Text(
            _readingFeedback,
            style: TextStyle(
              color: _readingFeedback == "Correct!" ? Colors.green : Colors.red,
            ),
          ),
        const SizedBox(height: 10),
        TextField(
          controller: _timeValueAnswerController,
          decoration: InputDecoration(
            labelText: 'Give Time (HH:MM)',
            border: OutlineInputBorder(),
            hintText: 'Enter time e.g., 07:30',
          ),
          keyboardType: TextInputType.datetime,
          onSubmitted: (_) => _submitAnswerLogic(
            _timeValueAnswerController,
            [widget.vocab.timeString],
            (f) => setState(() => _timeValueFeedback = f),
          ),
        ),
        const SizedBox(height: 5),
        FilledButton(
          onPressed: () => _submitAnswerLogic(
            _timeValueAnswerController,
            [widget.vocab.timeString],
            (f) => setState(() => _timeValueFeedback = f),
          ),
          child: const Text("Check Time Value"),
        ),
        const SizedBox(height: 5),
        if (_timeValueFeedback.isNotEmpty)
          Text(
            _timeValueFeedback,
            style: TextStyle(
              color: _timeValueFeedback == "Correct!"
                  ? Colors.green
                  : Colors.red,
            ),
          ),
      ],
    );
  }
}
