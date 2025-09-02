// lib/models/vocab.dart
// ----------------------
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lang_practice/models/vocab_meta.dart';

import '../services/logger_service.dart';
import '../services/srs.dart';

part 'vocab.g.dart';

// Note: If vocab_meta.g.dart is needed, it will be generated into vocab.g.dart
// as VocabMeta is defined in this file.

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

  Vocab({required this.type, VocabMeta? meta}) : meta = meta ?? VocabMeta() {
    LoggerService().d(
      'Vocab constructor called for type: $type, level: ${this.meta.level}, key: ${key?.toString() ?? "new"}',
    );
  }

  static Vocab create(VocabType type) {
    LoggerService().i('Vocab.create called for type: $type');
    // VocabMeta will be initialized with defaults by the Vocab constructor
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
    // Ensure meta is also saved if it's a separate HiveObject,
    // but here it's part of Vocab, so Hive handles it.
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
    return 'Type: ${type.name}, Level: ${meta.level}, Next Review: ${formatter.format(meta.nextReview)}';
  }

  @override
  String toString() {
    return 'Vocab{type: $type, meta: $meta, key: $key}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vocab && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key?.hashCode ?? super.hashCode;

  // Subclasses will call super.toJson() and add their specific fields.
  Map<String, dynamic> toJson() {
    return {'type': type.name, 'meta': meta.toJson()};
  }

  // fromJson is static and handled by subclasses which will create VocabMeta
  // and pass it to their constructor (which passes to super Vocab constructor)
  static Vocab fromJson(Map<String, dynamic> json) {
    final jsonString = json.toString();
    LoggerService().d(
      'Vocab.fromJson called with json: ${jsonString.substring(0, jsonString.length > 100 ? 100 : jsonString.length)}',
    );
    final typeStr = json['type'] as String?;
    if (typeStr == null) {
      final errorMsg =
          'Vocab.fromJson error: type field is missing or null in JSON.';
      LoggerService().e(errorMsg, 'Missing type in JSON', StackTrace.current);
      throw ArgumentError(errorMsg);
    }

    final type = VocabType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () {
        final errorMsg = 'Vocab.fromJson error: Unknown vocab type: $typeStr';
        LoggerService().e(errorMsg, 'Unknown vocab type', StackTrace.current);
        throw ArgumentError(errorMsg);
      },
    );

    // The actual Vocab object creation is delegated to subclass fromJson methods.
    // They will handle the 'meta' field.
    LoggerService().i('Vocab.fromJson: routing to $type.fromJson.');
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
