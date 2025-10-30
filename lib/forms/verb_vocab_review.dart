import 'package:flutter/material.dart';

import '../models/vocab.dart';
import '../services/srs.dart';

class VerbVocabReview extends StatefulWidget {
  final VerbVocab vocab;

  const VerbVocabReview({super.key, required this.vocab});

  @override
  State<StatefulWidget> createState() => VerbVocabReviewState();
}

class VerbVocabReviewState extends State<VerbVocabReview> {
  // // Review screen controllers
  late TextEditingController _readingAnswerController;
  late TextEditingController _meaningAnswerController;

  String _readingFeedback = '';
  String _meaningFeedback = '';

  @override
  void initState() {
    super.initState();
    _readingAnswerController = TextEditingController();
    _meaningAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    _readingAnswerController.dispose();
    _meaningAnswerController.dispose();
    super.dispose();
  }

  void _submitAnswerLogic(
    TextEditingController controller,
    List<String> correctAnswers,
    Function(String) feedbackSetter,
  ) {
    final userAnswer = controller.text.trim().toLowerCase();
    // SRS interaction will now use this.meta
    if (correctAnswers
        .map((ans) => ans.trim().toLowerCase())
        .contains(userAnswer)) {
      feedbackSetter("Correct!");
      SRS.markCorrect(widget.vocab);
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
      } else {
        feedbackSetter("Incorrect. Correct: $correctAnswers");
        SRS.markWrong(widget.vocab);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.vocab.plainVerb.verbWord,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (widget.vocab.notes.isNotEmpty)
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
            labelText: 'Reading of Plain Form',
            border: OutlineInputBorder(),
            hintText: 'Enter reading in hiragana/katakana',
          ),
          onSubmitted: (_) => _submitAnswerLogic(
            _readingAnswerController,
            widget.vocab.plainVerb.readings,
            (f) => setState(() => _readingFeedback = f),
          ),
        ),
        const SizedBox(height: 5),
        FilledButton(
          onPressed: () => _submitAnswerLogic(
            _readingAnswerController,
            widget.vocab.plainVerb.readings,
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
          controller: _meaningAnswerController,
          decoration: InputDecoration(
            labelText: 'Meaning of Plain Form',
            border: OutlineInputBorder(),
            hintText: 'Enter meaning in English',
          ),
          onSubmitted: (_) => _submitAnswerLogic(
            _meaningAnswerController,
            widget.vocab.plainVerb.meanings,
            (f) => setState(() => _meaningFeedback = f),
          ),
        ),
        const SizedBox(height: 5),
        FilledButton(
          onPressed: () => _submitAnswerLogic(
            _meaningAnswerController,
            widget.vocab.plainVerb.meanings,
            (f) => setState(() => _meaningFeedback = f),
          ),
          child: const Text("Check Meaning"),
        ),
        const SizedBox(height: 5),
        if (_meaningFeedback.isNotEmpty)
          Text(
            _meaningFeedback,
            style: TextStyle(
              color: _meaningFeedback == "Correct!" ? Colors.green : Colors.red,
            ),
          ),
      ],
    );
  }
}
