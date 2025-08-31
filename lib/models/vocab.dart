// lib/models/vocab.dart
// ----------------------
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../services/logger_service.dart';
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
  @HiveField(1)
  VocabType type;
  @HiveField(2)
  int level; // 0-10
  @HiveField(3)
  DateTime nextReview = DateTime.now(); // due time

  Vocab({required this.type, this.level = 0}) {
    LoggerService().d(
      'Vocab constructor called for type: $type, level: $level, key: ${key?.toString() ?? "new"}',
    );
  }

  static Vocab create(VocabType type) {
    LoggerService().i('Vocab.create called for type: $type');
    switch (type) {
      case VocabType.word:
        return WordVocab(word: '', meanings: [], readings: []);
      case VocabType.time:
        return TimeVocab(reading: '', timeString: '', timeWord: '');
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
    return 'Level: $level, Next Review: ${formatter.format(nextReview)}';
  }

  String displaySummary() {
    final DateFormat formatter = DateFormat.yMd();
    return 'Type: ${type.name}, Level: $level, Next Review: ${formatter.format(nextReview)}';
  }

  @override
  String toString() {
    return 'Vocab{type: $type, level: $level, nextReview: $nextReview, key: $key}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vocab && runtimeType == other.runtimeType && key == other.key; // Assuming key is primary identifier

  @override
  int get hashCode => key?.hashCode ?? super.hashCode;

  Map<String, dynamic> toJson();

  static Vocab fromJson(Map<String, dynamic> json) {
    final jsonString = json.toString();
    LoggerService().d(
      'Vocab.fromJson called with json: ${jsonString.substring(0, jsonString.length > 100 ? 100 : jsonString.length)}',
    );
    final typeStr = json['type'] as String?;
    if (typeStr == null) {
      LoggerService().e(
        'Vocab.fromJson error: type field is missing or null in JSON.',
        'Missing type in JSON',
        StackTrace.current,
      );
      throw ArgumentError(
        'Type field is missing or null in JSON for Vocab.fromJson',
      );
    }

    final type = VocabType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () {
        LoggerService().e(
          'Vocab.fromJson error: Unknown vocab type: $typeStr',
          'Unknown vocab type',
          StackTrace.current,
        );
        throw ArgumentError('Unknown vocab type: $typeStr');
      },
    );

    LoggerService().i('Vocab.fromJson: creating $type from JSON.');
    switch (type) {
      case VocabType.word:
        LoggerService().d('Vocab.fromJson: routing to WordVocab.fromJson');
        return WordVocab.fromJson(json);
      case VocabType.time:
        LoggerService().d('Vocab.fromJson: routing to TimeVocab.fromJson');
        return TimeVocab.fromJson(json);
      case VocabType.sentence:
        LoggerService().d('Vocab.fromJson: routing to SentenceVocab.fromJson');
        return SentenceVocab.fromJson(json);
      case VocabType.verb:
        LoggerService().d('Vocab.fromJson: routing to VerbVocab.fromJson');
        return VerbVocab.fromJson(json);
      // No default needed as orElse in firstWhere handles unknown types
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
