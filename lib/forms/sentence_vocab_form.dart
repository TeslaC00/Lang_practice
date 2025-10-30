import 'package:flutter/material.dart';

import '../helper_ui_comps.dart';
import '../models/vocab.dart';

class SentenceVocabForm extends StatefulWidget {
  final SentenceVocab vocab;
  final bool isNew;

  const SentenceVocabForm({super.key, required this.vocab, this.isNew = false});

  @override
  State<StatefulWidget> createState() => _SentenceVocabFormState();
}

class _SentenceVocabFormState extends State<SentenceVocabForm> {
  late TextEditingController _sentenceController;
  late TextEditingController _answerController;
  late TextEditingController _notesController; // Added notes controller

  final _formKey = GlobalKey<FormState>(); // Good for validation

  @override
  void initState() {
    super.initState();
    _sentenceController = TextEditingController(text: widget.vocab.sentence);
    _answerController = TextEditingController(text: widget.vocab.answer);
    _notesController = TextEditingController(
      text: widget.vocab.notes,
    ); // Initialize notes controller
  }

  @override
  void dispose() {
    _sentenceController.dispose();
    _answerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveForm() {
    widget.vocab.sentence = _sentenceController.text;
    widget.vocab.answer = _answerController.text;
    widget.vocab.notes = _notesController.text; // Update notes from controller

    if (widget.isNew) {
      widget.vocab.add();
    } else {
      widget.vocab.save();
    }

    //   Maybe pop the screen
    Navigator.of(context).pop();
  }

  // // Helper method for review logic
  // void _submitReviewAnswerLogic(
  //   TextEditingController controller,
  //   String correctAnswer,
  //   Function(String) feedbackSetter,
  // ) {
  //   final userAnswer = controller.text.trim().toLowerCase();
  //   if (correctAnswer.trim().toLowerCase() == userAnswer) {
  //     feedbackSetter("Correct!");
  //     SRS.markCorrect(this); // 'this' refers to SentenceVocab instance
  //   } else {
  //     if (userAnswer.isEmpty) {
  //       feedbackSetter("Please enter an answer.");
  //     } else {
  //       feedbackSetter("Incorrect. Correct: $correctAnswer");
  //       SRS.markWrong(this); // 'this' refers to SentenceVocab instance
  //     }
  //   }
  // }
  //
  // @override
  // List<Widget> buildFormFields(StateSetter setState) {
  //   return [
  //     _LabeledField(
  //       'Sentence (use __ for blanks)',
  //       _sentenceController,
  //       maxLines: 3,
  //     ),
  //     const SizedBox(height: 10),
  //     _LabeledField('Answer/Translation', _answerController, maxLines: 3),
  //     const SizedBox(height: 10),
  //     _LabeledField('Notes', _notesController, maxLines: 3),
  //   ];
  // }
  //
  // @override
  // List<Widget> buildReviewFields(StateSetter setState) {
  //   return [
  //     Text(
  //       sentence,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //     ),
  //     if (notes.isNotEmpty) // Display notes if they exist
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: Text(
  //           "Notes: $notes", // Notes are already displayed here
  //           style: TextStyle(fontStyle: FontStyle.italic),
  //         ),
  //       ),
  //     const SizedBox(height: 10),
  //     TextField(
  //       controller: _reviewAnswerController,
  //       decoration: InputDecoration(
  //         labelText: 'Your Answer',
  //         border: OutlineInputBorder(),
  //         hintText: 'Enter your translation or the missing part',
  //       ),
  //       onSubmitted: (_) => _submitReviewAnswerLogic(
  //         _reviewAnswerController,
  //         answer,
  //         (f) => setState(() => _reviewFeedback = f),
  //       ),
  //     ),
  //     const SizedBox(height: 5),
  //     FilledButton(
  //       onPressed: () => _submitReviewAnswerLogic(
  //         _reviewAnswerController,
  //         answer,
  //         (f) => setState(() => _reviewFeedback = f),
  //       ),
  //       child: const Text("Check Answer"),
  //     ),
  //     const SizedBox(height: 5),
  //     if (_reviewFeedback.isNotEmpty)
  //       Text(
  //         _reviewFeedback,
  //         style: TextStyle(
  //           color: _reviewFeedback == "Correct!" ? Colors.green : Colors.red,
  //         ),
  //       ),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LabeledField(
            'Sentence (use __ for blanks)',
            _sentenceController,
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          LabeledField('Answer/Translation', _answerController, maxLines: 3),
          const SizedBox(height: 10),
          LabeledField('Notes', _notesController, maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveForm,
            child: Text(widget.isNew ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }
}
