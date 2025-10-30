// lib/screens/add_edit_vocab_screen.dart
// ----------------------

import 'package:flutter/material.dart';
import 'package:lang_practice/services/logger_service.dart';
import '../models/vocab.dart';

class AddEditVocabScreen extends StatefulWidget {
  final Vocab? existing;

  const AddEditVocabScreen({super.key, this.existing});

  @override
  State<AddEditVocabScreen> createState() => _AddEditVocabScreenState();
}

class _AddEditVocabScreenState extends State<AddEditVocabScreen> {
  VocabType selectedType = VocabType.word;
  late Vocab _vocab;
  final LoggerService _logger = LoggerService();

  @override
  void initState() {
    _logger.d("_AddEditVocabScreenState.initState entry");
    super.initState();
    if (widget.existing == null) {
      _logger.i(
        "AddEditVocabScreen: Adding new entry. Initial type: $selectedType",
      );
      _vocab = Vocab.create(selectedType);
    } else {
      _logger.i(
        "AddEditVocabScreen: Editing existing entry. Type: ${widget.existing!.type}",
      );
      _vocab = widget.existing!;
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.d(
      "_AddEditVocabScreenState.build entry. Editing: ${widget.existing != null}",
    );
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
    _logger.d("_AddEditVocabScreenState._buildEditForm entry");
    return _vocab.buildFormWidget(isNew: false);
  }

  Widget _buildAddForm() {
    _logger.d("_AddEditVocabScreenState._buildAddForm entry");
    return Column(
      children: [
        DropdownButtonFormField<VocabType>(
          initialValue: selectedType,
          items: VocabType.values
              .map(
                (item) => DropdownMenuItem(value: item, child: Text(item.name)),
              )
              .toList(),
          onChanged: (value) {
            _logger.i("VocabType changed. New type: $value");
            setState(() {
              selectedType = value!;
              _vocab = Vocab.create(selectedType);
              _logger.d("_vocab updated with new type: ${selectedType.name}");
            });
          },
          decoration: const InputDecoration(labelText: "Select Vocab Type"),
        ),
        const SizedBox(height: 16),
        _vocab.buildFormWidget(isNew: true),
      ],
    );
  }
}
