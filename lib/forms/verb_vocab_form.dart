import 'package:flutter/material.dart';

import '../helper_ui_comps.dart';
import '../models/vocab.dart';

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

  void _saveForm() {
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

    if (widget.isNew) {
      widget.vocab.add();
    } else {
      widget.vocab.save();
    }

    //   Maybe pop the screen
    Navigator.of(context).pop();
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
