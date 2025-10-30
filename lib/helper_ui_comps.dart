// Private helper widget, kept in the main file as it's used across different vocab forms.
import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const LabeledField(
    this.label,
    this.controller, {
    super.key,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
