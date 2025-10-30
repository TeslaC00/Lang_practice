import 'package:flutter/material.dart';

import '../helper_ui_comps.dart';
import '../models/vocab.dart';
import '../services/database.dart';
import 'package:drift/drift.dart' as drift;

import '../vocab_mapper.dart';

class VerbVocabForm extends StatefulWidget {
  final VerbVocab vocab;
  final bool isNew;

  const VerbVocabForm({super.key, required this.vocab, this.isNew = false});

  @override
  State<StatefulWidget> createState() => _VerbVocabFormState();
}

class _VerbVocabFormState extends State<VerbVocabForm> {
  late TextEditingController _plainVerbWordController;
  late TextEditingController _plainVerbReadingController;
  late TextEditingController _plainVerbMeaningController;
  late TextEditingController _notesController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _plainVerbWordController = TextEditingController(
      text: widget.vocab.plainVerb.verbWord,
    );
    _plainVerbReadingController = TextEditingController(
      text: widget.vocab.plainVerb.readings.join(', '),
    );
    _plainVerbMeaningController = TextEditingController(
      text: widget.vocab.plainVerb.meanings.join(', '),
    );
    _notesController = TextEditingController(
      text: widget.vocab.notes,
    ); // Initialize notes controller
  }

  @override
  void dispose() {
    _plainVerbWordController.dispose();
    _plainVerbReadingController.dispose();
    _plainVerbMeaningController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final db = AppDatabase.instance;

    widget.vocab.plainVerb.verbWord = _plainVerbWordController.text.trim();
    widget.vocab.plainVerb.readings = _plainVerbReadingController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    widget.vocab.plainVerb.meanings = _plainVerbMeaningController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    widget.vocab.notes = _notesController.text.trim();

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
    List<Widget> formWidgets = [
      LabeledField('Plain Verb Word (e.g., 食べる)', _plainVerbWordController),
      const SizedBox(height: 10),
      LabeledField(
        'Plain Verb Reading (e.g., たべる)',
        _plainVerbReadingController,
      ),
      const SizedBox(height: 10),
      LabeledField(
        'Plain Verb Meaning(s) (e.g., to eat, to consume - comma separated)',
        _plainVerbMeaningController,
      ),
      const SizedBox(height: 10),
      LabeledField('Notes', _notesController, maxLines: 3),
      const SizedBox(height: 10),
      const Text('Verb Forms:', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
    ];

    // Add the verb form widgets
    formWidgets.addAll(
      widget.vocab.verbForms.entries.map((entry) {
        final key = entry.key;
        final verbForm = entry.value;
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
          child: Text('$key: ${verbForm.displaySummary()}'),
        );
      }),
    );

    formWidgets.addAll([
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: _saveForm,
        child: Text(widget.isNew ? 'Create' : 'Save'),
      ),
    ]);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: formWidgets,
        ),
      ),
    );
  }
}
