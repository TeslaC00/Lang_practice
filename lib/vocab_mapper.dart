import 'package:lang_practice/services/database.dart';

import 'models/vocab.dart';
import 'package:drift/drift.dart' as drift;

import 'models/vocab_meta.dart';

class VocabMapper {
  static VocabsCompanion vocabToCompanion(Vocab vocab) {
    // Common
    final meta = vocab.meta;
    final companion = VocabsCompanion.insert(
      // meta data
      level: meta.level,
      isNew: meta.isNew,
      nextReview: meta.nextReview,
      lastReview: drift.Value(meta.lastReview),
      correctTimesCounter: meta.correctTimesCounter,
      wrongTimesCounter: meta.wrongTimesCounter,
      totalCorrectTimes: meta.totalCorrectTimes,
      totalWrongTimes: meta.totalWrongTimes,
      // common values
      type: vocab.type,
      notes: vocab.notes,
      primaryText: '',
    );

    //   Sub-type data
    switch (vocab.type) {
      case VocabType.word:
        final w = vocab as WordVocab;
        return companion.copyWith(
          word: drift.Value(w.word),
          wordReadings: drift.Value(w.readings),
          wordMeanings: drift.Value(w.meanings),
          primaryText: drift.Value(w.word),
        );
      case VocabType.sentence:
        final s = vocab as SentenceVocab;
        return companion.copyWith(
          sentence: drift.Value(s.sentence),
          answer: drift.Value(s.answer),
          primaryText: drift.Value(s.sentence),
        );
      case VocabType.time:
        final t = vocab as TimeVocab;
        return companion.copyWith(
          timeWord: drift.Value(t.timeWord),
          timeReadings: drift.Value(t.readings),
          timeString: drift.Value(t.timeString),
          primaryText: drift.Value(t.timeString),
        );
      case VocabType.verb:
        final v = vocab as VerbVocab;
        return companion.copyWith(
          verbPlain: drift.Value(v.plainVerb),
          verbForms: drift.Value(v.verbForms),
          primaryText: drift.Value(v.plainVerb.verbWord),
        );
    }
  }

  static Vocab entryToVocab(VocabEntry entry) {
    final meta = VocabMeta(
      level: entry.level,
      isNew: entry.isNew,
      nextReview: entry.nextReview,
      lastReview: entry.lastReview,
      correctTimesCounter: entry.correctTimesCounter,
      wrongTimesCounter: entry.wrongTimesCounter,
      totalCorrectTimes: entry.totalCorrectTimes,
      totalWrongTimes: entry.totalWrongTimes,
    );

    switch (entry.type) {
      case VocabType.word:
        return WordVocab(
          id: entry.id,
          word: entry.word!,
          readings: entry.wordReadings!,
          meanings: entry.wordMeanings!,
          notes: entry.notes,
          meta: meta,
        );
      case VocabType.sentence:
        return SentenceVocab(
          id: entry.id,
          sentence: entry.sentence!,
          answer: entry.answer!,
          notes: entry.notes,
          meta: meta,
        );
      case VocabType.time:
        return TimeVocab(
          id: entry.id,
          timeWord: entry.timeWord!,
          readings: entry.timeReadings!,
          timeString: entry.timeString!,
          notes: entry.notes,
          meta: meta,
        );

      case VocabType.verb:
        return VerbVocab(
          id: entry.id,
          plainVerb: entry.verbPlain!,
          verbForms: entry.verbForms!,
          notes: entry.notes,
          meta: meta,
        );
    }
  }
}
