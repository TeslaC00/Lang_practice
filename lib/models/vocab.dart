// lib/models/vocab.dart
// ----------------------
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'vocab.g.dart';

part 'word_vocab.dart';

part 'time_vocab.dart';

part 'sentence_vocab.dart';

part 'verb_form.dart';

part 'verb_vocab.dart';

@HiveType(typeId: 1)
enum VocabType {
  @HiveField(0)
  word,
  @HiveField(1)
  verb,
  @HiveField(2)
  sentence,
  @HiveField(3)
  time,
}

abstract class Vocab extends HiveObject {
  @HiveField(1)
  VocabType type;
  @HiveField(2)
  int level; // 0-10
  @HiveField(3)
  DateTime nextReview = DateTime.now(); // due time

  Vocab({required this.type, this.level = 0});

  static Vocab create(VocabType type) {
    switch (type) {
      case VocabType.word:
        return WordVocab(word: '', meanings: [], readings: []);
      case VocabType.time:
        return TimeVocab(reading: '', timeValue: TimeOfDay.now(), timeWord: '');
      case VocabType.sentence:
        return SentenceVocab(sentence: '', answer: '');
      case VocabType.verb:
        return VerbVocab(
          plainVerb: VerbForm(verbWord: '', reading: '', meaning: ''),
          verbForms: HashMap(),
        );
    }
  }

  List<Widget> buildFormFields(StateSetter setState);

  String displayTitle() {
    return type.name;
  }

  String displaySubtext() {
    final DateFormat formatter = DateFormat.yMd();
    return 'Level: $level, Next Review: ${formatter.format(nextReview)}';
  }

  String displaySummary() {
    final DateFormat formatter = DateFormat.yMd();
    return 'Type: ${type.name}, Level: $level, Next Review: ${formatter.format(nextReview)}';
  }

  @override
  String toString() {
    return 'Vocab{type: $type, level: $level, nextReview: $nextReview}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vocab && runtimeType == other.runtimeType;

  @override
  int get hashCode => nextReview.hashCode;
}

// Private helper widget, kept in the main file as it's used across different vocab forms.
class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _LabeledField(this.label, this.controller, {this.maxLines = 1});

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
