
import 'package:flutter/material.dart';

import '../models/vocab.dart';
import '../services/srs.dart';

class SentenceVocabReview extends StatefulWidget {
  final SentenceVocab vocab;

  const SentenceVocabReview({super.key, required this.vocab});

  @override
  State<StatefulWidget> createState() => _SentenceVocabReviewState();
}

class _SentenceVocabReviewState extends State<SentenceVocabReview> {
  late TextEditingController _reviewAnswerController;

  String _reviewFeedback = ''; // Feedback for the review screen

  @override
  void initState() {
    super.initState();
    _reviewAnswerController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewAnswerController.dispose();
    super.dispose();
  }

  void _submitAnswerLogic(
      TextEditingController controller,
      String correctAnswer,
      Function(String) feedbackSetter,
      ) {
    final userAnswer = controller.text.trim().toLowerCase();
    if (correctAnswer.trim().toLowerCase() == userAnswer) {
      feedbackSetter("Correct!");
      SRS.markCorrect(widget.vocab);
    } else {
      if (userAnswer.isEmpty) {
        feedbackSetter("Please enter an answer.");
      } else {
        feedbackSetter("Incorrect. Correct: $correctAnswer");
        SRS.markWrong(widget.vocab);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.vocab.sentence,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (widget.vocab.notes.isNotEmpty) // Display notes if they exist
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Notes: ${widget.vocab.notes}",
              // Notes are already displayed here
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        const SizedBox(height: 10),
        TextField(
          controller: _reviewAnswerController,
          decoration: InputDecoration(
            labelText: 'Your Answer',
            border: OutlineInputBorder(),
            hintText: 'Enter your translation or the missing part',
          ),
          onSubmitted: (_) => _submitAnswerLogic(
            _reviewAnswerController,
            widget.vocab.answer,
                (f) => setState(() => _reviewFeedback = f),
          ),
        ),
        const SizedBox(height: 5),
        FilledButton(
          onPressed: () => _submitAnswerLogic(
            _reviewAnswerController,
            widget.vocab.answer,
                (f) => setState(() => _reviewFeedback = f),
          ),
          child: const Text("Check Answer"),
        ),
        const SizedBox(height: 5),
        if (_reviewFeedback.isNotEmpty)
          Text(
            _reviewFeedback,
            style: TextStyle(
              color: _reviewFeedback == "Correct!" ? Colors.green : Colors.red,
            ),
          ),
      ],
    );
  }
}