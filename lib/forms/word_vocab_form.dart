import 'package:flutter/material.dart';

import '../helper_ui_comps.dart';
import '../models/vocab.dart';
import '../services/database.dart';
import 'package:drift/drift.dart' as drift;

import '../vocab_mapper.dart';

class WordVocabForm extends StatefulWidget {
  final WordVocab vocab;
  final bool isNew;

  const WordVocabForm({super.key, required this.vocab, this.isNew = false});

  @override
  State<StatefulWidget> createState() => _WordVocabFormState();
}

class _WordVocabFormState extends State<WordVocabForm> {
  //   All the controller and state live here
  late TextEditingController _wordController;
  late TextEditingController _meaningsController;
  late TextEditingController _readingsController;
  late TextEditingController _notesController;

  final _formKey = GlobalKey<FormState>(); // Good for validation

  @override
  void initState() {
    super.initState();
    // Initialize all controller from model
    _wordController = TextEditingController(text: widget.vocab.word);
    _meaningsController = TextEditingController(
      text: widget.vocab.meanings.join(', '),
    );
    _readingsController = TextEditingController(
      text: widget.vocab.readings.join(', '),
    );
    _notesController = TextEditingController(text: widget.vocab.notes);
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningsController.dispose();
    _readingsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // save and add logic
  void _saveForm() async {
    final db = AppDatabase.instance;

    widget.vocab.word = _wordController.text;
    widget.vocab.readings = _readingsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    widget.vocab.meanings = _meaningsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
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
          LabeledField('Word (kanji/word)', _wordController),
          const SizedBox(height: 10),
          LabeledField(
            'Readings (ひらがな etc., comma separated)',
            _readingsController,
          ),
          const SizedBox(height: 10),
          LabeledField(
            'Meanings/English (comma separated)',
            _meaningsController,
          ),
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
