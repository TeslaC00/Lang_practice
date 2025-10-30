// lib/models/vocab.dart
// ----------------------
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lang_practice/models/vocab_meta.dart';

import '../forms/sentence_vocab_form.dart';
import '../forms/sentence_vocab_review.dart';
import '../forms/time_vocab_form.dart';
import '../forms/time_vocab_review.dart';
import '../forms/verb_vocab_form.dart';
import '../forms/verb_vocab_review.dart';
import '../forms/word_vocab_form.dart';
import '../forms/word_vocab_review.dart';

part 'sentence_vocab.dart';

part 'time_vocab.dart';

part 'verb_form.dart';

part 'verb_vocab.dart';

part 'word_vocab.dart';

enum VocabType { word, verb, sentence, time }

abstract class Vocab {
  int? id;

  VocabType type;
  VocabMeta meta;
  String notes;

  Vocab({this.id, required this.type, VocabMeta? meta, this.notes = ''})
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

  Widget buildFormWidget({bool isNew = false});

  Widget buildReviewWidget();

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
    return 'Vocab{type: $type, notes: $notes, meta: $meta, id: $id}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vocab && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id?.hashCode ?? super.hashCode;

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
