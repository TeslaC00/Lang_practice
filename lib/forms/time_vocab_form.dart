import 'package:flutter/material.dart';

import '../helper_ui_comps.dart';
import '../models/vocab.dart';
import '../services/database.dart';
import 'package:drift/drift.dart' as drift;

import '../vocab_mapper.dart';

class TimeVocabForm extends StatefulWidget {
  final TimeVocab vocab;
  final bool isNew;

  const TimeVocabForm({super.key, required this.vocab, this.isNew = false});

  @override
  State<StatefulWidget> createState() => _TimeVocabFormState();
}

class _TimeVocabFormState extends State<TimeVocabForm> {
  late TextEditingController _timeWordController;
  late TextEditingController _readingController;
  late TextEditingController _timeValueController; // For form input
  late TextEditingController _notesController; // Added for notes

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _timeWordController = TextEditingController(text: widget.vocab.timeWord);
    _readingController = TextEditingController(
      text: widget.vocab.readings.join(', '),
    );
    _timeValueController = TextEditingController(text: widget.vocab.timeString);
    _notesController = TextEditingController(
      text: widget.vocab.notes,
    ); // Initialize notes controller
  }

  @override
  void dispose() {
    _timeWordController.dispose();
    _readingController.dispose();
    _timeValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final db = AppDatabase.instance;

    widget.vocab.timeWord = _timeWordController.text;
    widget.vocab.readings = _readingController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    widget.vocab.timeString = _timeValueController.text;
    widget.vocab.notes = _notesController.text; // Get notes from controller
    // meta is already part of the object, managed by Vocab class

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
          LabeledField('Time Word (e.g., 7:30 AM, 今)', _timeWordController),
          const SizedBox(height: 10),
          LabeledField('Reading (e.g., しちじはん, いま)', _readingController),
          const SizedBox(height: 10),
          LabeledField('Time Value (HH:mm e.g., 07:30)', _timeValueController),
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
