import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import '../helper_ui_comps.dart';
import '../models/vocab.dart';
import '../services/database.dart';

import '../vocab_mapper.dart';

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

  void _saveForm() async {
    final db = AppDatabase.instance;

    widget.vocab.sentence = _sentenceController.text;
    widget.vocab.answer = _answerController.text;
    widget.vocab.notes = _notesController.text; // Update notes from controller

    final companion = VocabMapper.vocabToCompanion(widget.vocab).copyWith(
      id: widget.isNew ? drift.Value.absent() : drift.Value(widget.vocab.id!),
    );

    try {
      if (widget.isNew) {
        await db.into(db.vocabs).insert(companion);
      } else {
        await db.update(db.vocabs).replace(companion);
      }

      if (!mounted) return;

      Navigator.of(context).pop();
    } on Exception catch (e) {
      // Handle error show a SnackBar
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving: $e")));
    }
  }

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
