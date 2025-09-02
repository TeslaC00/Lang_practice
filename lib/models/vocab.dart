// lib/models/vocab.dart
// ----------------------
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lang_practice/models/vocab_meta.dart';

import '../services/srs.dart';

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
  @HiveField(0)
  VocabType type;

  @HiveField(1)
  VocabMeta meta;

  @HiveField(2)
  String notes;

  Vocab({required this.type, VocabMeta? meta, this.notes = ''})
    : meta = meta ?? VocabMeta();

  static Vocab create(VocabType type) {
    // VocabMeta will be initialized with defaults by the Vocab constructor
    // Notes will default to ''
    switch (type) {
      case VocabType.word:
        return WordVocab(word: '', meanings: [], readings: []);
      case VocabType.time:
        return TimeVocab(readings: [], timeString: '', timeWord: '');
      case VocabType.sentence:
        return SentenceVocab(sentence: '', answer: '');
      case VocabType.verb:
        return VerbVocab(
          plainVerb: VerbForm(verbWord: '', readings: [], meanings: []),
          verbForms: HashMap(),
        );
    }
  }

  List<Widget> buildFormFields(StateSetter setState);

  List<Widget> buildReviewFields(StateSetter setState);

  void dispose();

  void add();

  Future<void> addToBox() async {
    final box = Hive.box<Vocab>('vocabBox');
    await box.add(this);
  }

  String displayTitle() {
    return type.name;
  }

  String displaySubtext() {
    final DateFormat formatter = DateFormat.yMd();
    return 'Level: ${meta.level}, Next Review: ${formatter.format(meta.nextReview)}';
  }

  String displaySummary() {
    final DateFormat formatter = DateFormat.yMd();
    return 'Type: ${type.name}, Notes: $notes, Level: ${meta.level}, Next Review: ${formatter.format(meta.nextReview)}';
  }

  @override
  String toString() {
    return 'Vocab{type: $type, notes: $notes, meta: $meta, key: $key}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vocab && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key?.hashCode ?? super.hashCode;

  Map<String, dynamic> toJson() {
    return {'type': type.name, 'notes': notes, 'meta': meta.toJson()};
  }

  static Vocab fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String?;
    if (typeStr == null) {
      final errorMsg =
          'Vocab.fromJson error: type field is missing or null in JSON.';
      throw ArgumentError(errorMsg);
    }

    final type = VocabType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () {
        final errorMsg = 'Vocab.fromJson error: Unknown vocab type: $typeStr';
        throw ArgumentError(errorMsg);
      },
    );
    // notes will be extracted by subclasses and passed to their constructor.
    // meta will be extracted by subclasses and passed.

    switch (type) {
      case VocabType.word:
        return WordVocab.fromJson(json);
      case VocabType.time:
        return TimeVocab.fromJson(json);
      case VocabType.sentence:
        return SentenceVocab.fromJson(json);
      case VocabType.verb:
        return VerbVocab.fromJson(json);
    }
  }
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
