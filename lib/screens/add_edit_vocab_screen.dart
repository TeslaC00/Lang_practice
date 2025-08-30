// lib/screens/add_edit_vocab_screen.dart
// ----------------------

import 'package:flutter/material.dart';
import 'package:lang_practice/models/vocab.dart';

class AddEditVocabScreen extends StatefulWidget {
  final Vocab? existing;

  const AddEditVocabScreen({super.key, this.existing});

  @override
  State<AddEditVocabScreen> createState() => _AddEditVocabScreenState();
}

class _AddEditVocabScreenState extends State<AddEditVocabScreen> {
  VocabType selectedType = VocabType.word;
  late Vocab _vocab;

  @override
  void initState() {
    super.initState();
    _vocab = widget.existing ?? Vocab.create(selectedType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add Entry' : 'Edit Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: widget.existing != null ? _buildEditForm() : _buildAddForm(),
      ),
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        ..._vocab.buildFormFields(setState),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            _vocab.save();
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }

  Widget _buildAddForm() {
    return Column(
      children: [
        DropdownButtonFormField<VocabType>(
          initialValue: selectedType,
          items: VocabType.values
              .map(
                (item) => DropdownMenuItem(value: item, child: Text(item.name)),
              )
              .toList(),
          onChanged: (value) => setState(() {
            selectedType = value!;
            _vocab = Vocab.create(selectedType);
          }),
          decoration: const InputDecoration(labelText: "Select Vocab Type"),
        ),
        const SizedBox(height: 16),
        ..._vocab.buildFormFields(setState),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            _vocab.save();
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
