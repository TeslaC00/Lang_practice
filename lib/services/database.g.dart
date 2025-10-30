// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $VocabsTable extends Vocabs with TableInfo<$VocabsTable, VocabEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _primaryTextMeta =
      const VerificationMeta('primaryText');
  @override
  late final GeneratedColumn<String> primaryText = GeneratedColumn<String>(
      'primary_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<VocabType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<VocabType>($VocabsTable.$convertertype);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nextReviewMeta =
      const VerificationMeta('nextReview');
  @override
  late final GeneratedColumn<DateTime> nextReview = GeneratedColumn<DateTime>(
      'next_review', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew = GeneratedColumn<bool>(
      'is_new', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_new" IN (0, 1))'));
  static const VerificationMeta _totalCorrectTimesMeta =
      const VerificationMeta('totalCorrectTimes');
  @override
  late final GeneratedColumn<int> totalCorrectTimes = GeneratedColumn<int>(
      'total_correct_times', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalWrongTimesMeta =
      const VerificationMeta('totalWrongTimes');
  @override
  late final GeneratedColumn<int> totalWrongTimes = GeneratedColumn<int>(
      'total_wrong_times', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _correctTimesCounterMeta =
      const VerificationMeta('correctTimesCounter');
  @override
  late final GeneratedColumn<int> correctTimesCounter = GeneratedColumn<int>(
      'correct_times_counter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wrongTimesCounterMeta =
      const VerificationMeta('wrongTimesCounter');
  @override
  late final GeneratedColumn<int> wrongTimesCounter = GeneratedColumn<int>(
      'wrong_times_counter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastReviewMeta =
      const VerificationMeta('lastReview');
  @override
  late final GeneratedColumn<DateTime> lastReview = GeneratedColumn<DateTime>(
      'last_review', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _wordReadingsMeta =
      const VerificationMeta('wordReadings');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      wordReadings = GeneratedColumn<String>('word_readings', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>($VocabsTable.$converterwordReadingsn);
  static const VerificationMeta _wordMeaningsMeta =
      const VerificationMeta('wordMeanings');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      wordMeanings = GeneratedColumn<String>('word_meanings', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>($VocabsTable.$converterwordMeaningsn);
  static const VerificationMeta _sentenceMeta =
      const VerificationMeta('sentence');
  @override
  late final GeneratedColumn<String> sentence = GeneratedColumn<String>(
      'sentence', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timeWordMeta =
      const VerificationMeta('timeWord');
  @override
  late final GeneratedColumn<String> timeWord = GeneratedColumn<String>(
      'time_word', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timeReadingsMeta =
      const VerificationMeta('timeReadings');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      timeReadings = GeneratedColumn<String>('time_readings', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>($VocabsTable.$convertertimeReadingsn);
  static const VerificationMeta _timeStringMeta =
      const VerificationMeta('timeString');
  @override
  late final GeneratedColumn<String> timeString = GeneratedColumn<String>(
      'time_string', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verbPlainMeta =
      const VerificationMeta('verbPlain');
  @override
  late final GeneratedColumnWithTypeConverter<VerbForm?, String> verbPlain =
      GeneratedColumn<String>('verb_plain', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<VerbForm?>($VocabsTable.$converterverbPlainn);
  static const VerificationMeta _verbFormsMeta =
      const VerificationMeta('verbForms');
  @override
  late final GeneratedColumnWithTypeConverter<HashMap<String, VerbForm>?,
      String> verbForms = GeneratedColumn<String>(
          'verb_forms', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false)
      .withConverter<HashMap<String, VerbForm>?>(
          $VocabsTable.$converterverbFormsn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        primaryText,
        type,
        notes,
        level,
        nextReview,
        isNew,
        totalCorrectTimes,
        totalWrongTimes,
        correctTimesCounter,
        wrongTimesCounter,
        lastReview,
        word,
        wordReadings,
        wordMeanings,
        sentence,
        answer,
        timeWord,
        timeReadings,
        timeString,
        verbPlain,
        verbForms
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabs';
  @override
  VerificationContext validateIntegrity(Insertable<VocabEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('primary_text')) {
      context.handle(
          _primaryTextMeta,
          primaryText.isAcceptableOrUnknown(
              data['primary_text']!, _primaryTextMeta));
    } else if (isInserting) {
      context.missing(_primaryTextMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('next_review')) {
      context.handle(
          _nextReviewMeta,
          nextReview.isAcceptableOrUnknown(
              data['next_review']!, _nextReviewMeta));
    } else if (isInserting) {
      context.missing(_nextReviewMeta);
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    } else if (isInserting) {
      context.missing(_isNewMeta);
    }
    if (data.containsKey('total_correct_times')) {
      context.handle(
          _totalCorrectTimesMeta,
          totalCorrectTimes.isAcceptableOrUnknown(
              data['total_correct_times']!, _totalCorrectTimesMeta));
    } else if (isInserting) {
      context.missing(_totalCorrectTimesMeta);
    }
    if (data.containsKey('total_wrong_times')) {
      context.handle(
          _totalWrongTimesMeta,
          totalWrongTimes.isAcceptableOrUnknown(
              data['total_wrong_times']!, _totalWrongTimesMeta));
    } else if (isInserting) {
      context.missing(_totalWrongTimesMeta);
    }
    if (data.containsKey('correct_times_counter')) {
      context.handle(
          _correctTimesCounterMeta,
          correctTimesCounter.isAcceptableOrUnknown(
              data['correct_times_counter']!, _correctTimesCounterMeta));
    } else if (isInserting) {
      context.missing(_correctTimesCounterMeta);
    }
    if (data.containsKey('wrong_times_counter')) {
      context.handle(
          _wrongTimesCounterMeta,
          wrongTimesCounter.isAcceptableOrUnknown(
              data['wrong_times_counter']!, _wrongTimesCounterMeta));
    } else if (isInserting) {
      context.missing(_wrongTimesCounterMeta);
    }
    if (data.containsKey('last_review')) {
      context.handle(
          _lastReviewMeta,
          lastReview.isAcceptableOrUnknown(
              data['last_review']!, _lastReviewMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    }
    context.handle(_wordReadingsMeta, const VerificationResult.success());
    context.handle(_wordMeaningsMeta, const VerificationResult.success());
    if (data.containsKey('sentence')) {
      context.handle(_sentenceMeta,
          sentence.isAcceptableOrUnknown(data['sentence']!, _sentenceMeta));
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    }
    if (data.containsKey('time_word')) {
      context.handle(_timeWordMeta,
          timeWord.isAcceptableOrUnknown(data['time_word']!, _timeWordMeta));
    }
    context.handle(_timeReadingsMeta, const VerificationResult.success());
    if (data.containsKey('time_string')) {
      context.handle(
          _timeStringMeta,
          timeString.isAcceptableOrUnknown(
              data['time_string']!, _timeStringMeta));
    }
    context.handle(_verbPlainMeta, const VerificationResult.success());
    context.handle(_verbFormsMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      primaryText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}primary_text'])!,
      type: $VocabsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      nextReview: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_review'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      totalCorrectTimes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_correct_times'])!,
      totalWrongTimes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_wrong_times'])!,
      correctTimesCounter: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}correct_times_counter'])!,
      wrongTimesCounter: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}wrong_times_counter'])!,
      lastReview: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_review']),
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word']),
      wordReadings: $VocabsTable.$converterwordReadingsn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}word_readings'])),
      wordMeanings: $VocabsTable.$converterwordMeaningsn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}word_meanings'])),
      sentence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sentence']),
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer']),
      timeWord: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_word']),
      timeReadings: $VocabsTable.$convertertimeReadingsn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}time_readings'])),
      timeString: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_string']),
      verbPlain: $VocabsTable.$converterverbPlainn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verb_plain'])),
      verbForms: $VocabsTable.$converterverbFormsn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verb_forms'])),
    );
  }

  @override
  $VocabsTable createAlias(String alias) {
    return $VocabsTable(attachedDatabase, alias);
  }

  static TypeConverter<VocabType, String> $convertertype =
      const VocabTypeConverter();
  static TypeConverter<List<String>, String> $converterwordReadings =
      const ListConverter();
  static TypeConverter<List<String>?, String?> $converterwordReadingsn =
      NullAwareTypeConverter.wrap($converterwordReadings);
  static TypeConverter<List<String>, String> $converterwordMeanings =
      const ListConverter();
  static TypeConverter<List<String>?, String?> $converterwordMeaningsn =
      NullAwareTypeConverter.wrap($converterwordMeanings);
  static TypeConverter<List<String>, String> $convertertimeReadings =
      const ListConverter();
  static TypeConverter<List<String>?, String?> $convertertimeReadingsn =
      NullAwareTypeConverter.wrap($convertertimeReadings);
  static TypeConverter<VerbForm, String> $converterverbPlain =
      const VerbFormConverter();
  static TypeConverter<VerbForm?, String?> $converterverbPlainn =
      NullAwareTypeConverter.wrap($converterverbPlain);
  static TypeConverter<HashMap<String, VerbForm>, String> $converterverbForms =
      const VerbMapConverter();
  static TypeConverter<HashMap<String, VerbForm>?, String?>
      $converterverbFormsn = NullAwareTypeConverter.wrap($converterverbForms);
}

class VocabEntry extends DataClass implements Insertable<VocabEntry> {
  final int id;
  final String primaryText;
  final VocabType type;
  final String notes;
  final int level;
  final DateTime nextReview;
  final bool isNew;
  final int totalCorrectTimes;
  final int totalWrongTimes;
  final int correctTimesCounter;
  final int wrongTimesCounter;
  final DateTime? lastReview;
  final String? word;
  final List<String>? wordReadings;
  final List<String>? wordMeanings;
  final String? sentence;
  final String? answer;
  final String? timeWord;
  final List<String>? timeReadings;
  final String? timeString;
  final VerbForm? verbPlain;
  final HashMap<String, VerbForm>? verbForms;
  const VocabEntry(
      {required this.id,
      required this.primaryText,
      required this.type,
      required this.notes,
      required this.level,
      required this.nextReview,
      required this.isNew,
      required this.totalCorrectTimes,
      required this.totalWrongTimes,
      required this.correctTimesCounter,
      required this.wrongTimesCounter,
      this.lastReview,
      this.word,
      this.wordReadings,
      this.wordMeanings,
      this.sentence,
      this.answer,
      this.timeWord,
      this.timeReadings,
      this.timeString,
      this.verbPlain,
      this.verbForms});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['primary_text'] = Variable<String>(primaryText);
    {
      map['type'] = Variable<String>($VocabsTable.$convertertype.toSql(type));
    }
    map['notes'] = Variable<String>(notes);
    map['level'] = Variable<int>(level);
    map['next_review'] = Variable<DateTime>(nextReview);
    map['is_new'] = Variable<bool>(isNew);
    map['total_correct_times'] = Variable<int>(totalCorrectTimes);
    map['total_wrong_times'] = Variable<int>(totalWrongTimes);
    map['correct_times_counter'] = Variable<int>(correctTimesCounter);
    map['wrong_times_counter'] = Variable<int>(wrongTimesCounter);
    if (!nullToAbsent || lastReview != null) {
      map['last_review'] = Variable<DateTime>(lastReview);
    }
    if (!nullToAbsent || word != null) {
      map['word'] = Variable<String>(word);
    }
    if (!nullToAbsent || wordReadings != null) {
      map['word_readings'] = Variable<String>(
          $VocabsTable.$converterwordReadingsn.toSql(wordReadings));
    }
    if (!nullToAbsent || wordMeanings != null) {
      map['word_meanings'] = Variable<String>(
          $VocabsTable.$converterwordMeaningsn.toSql(wordMeanings));
    }
    if (!nullToAbsent || sentence != null) {
      map['sentence'] = Variable<String>(sentence);
    }
    if (!nullToAbsent || answer != null) {
      map['answer'] = Variable<String>(answer);
    }
    if (!nullToAbsent || timeWord != null) {
      map['time_word'] = Variable<String>(timeWord);
    }
    if (!nullToAbsent || timeReadings != null) {
      map['time_readings'] = Variable<String>(
          $VocabsTable.$convertertimeReadingsn.toSql(timeReadings));
    }
    if (!nullToAbsent || timeString != null) {
      map['time_string'] = Variable<String>(timeString);
    }
    if (!nullToAbsent || verbPlain != null) {
      map['verb_plain'] =
          Variable<String>($VocabsTable.$converterverbPlainn.toSql(verbPlain));
    }
    if (!nullToAbsent || verbForms != null) {
      map['verb_forms'] =
          Variable<String>($VocabsTable.$converterverbFormsn.toSql(verbForms));
    }
    return map;
  }

  VocabsCompanion toCompanion(bool nullToAbsent) {
    return VocabsCompanion(
      id: Value(id),
      primaryText: Value(primaryText),
      type: Value(type),
      notes: Value(notes),
      level: Value(level),
      nextReview: Value(nextReview),
      isNew: Value(isNew),
      totalCorrectTimes: Value(totalCorrectTimes),
      totalWrongTimes: Value(totalWrongTimes),
      correctTimesCounter: Value(correctTimesCounter),
      wrongTimesCounter: Value(wrongTimesCounter),
      lastReview: lastReview == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReview),
      word: word == null && nullToAbsent ? const Value.absent() : Value(word),
      wordReadings: wordReadings == null && nullToAbsent
          ? const Value.absent()
          : Value(wordReadings),
      wordMeanings: wordMeanings == null && nullToAbsent
          ? const Value.absent()
          : Value(wordMeanings),
      sentence: sentence == null && nullToAbsent
          ? const Value.absent()
          : Value(sentence),
      answer:
          answer == null && nullToAbsent ? const Value.absent() : Value(answer),
      timeWord: timeWord == null && nullToAbsent
          ? const Value.absent()
          : Value(timeWord),
      timeReadings: timeReadings == null && nullToAbsent
          ? const Value.absent()
          : Value(timeReadings),
      timeString: timeString == null && nullToAbsent
          ? const Value.absent()
          : Value(timeString),
      verbPlain: verbPlain == null && nullToAbsent
          ? const Value.absent()
          : Value(verbPlain),
      verbForms: verbForms == null && nullToAbsent
          ? const Value.absent()
          : Value(verbForms),
    );
  }

  factory VocabEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabEntry(
      id: serializer.fromJson<int>(json['id']),
      primaryText: serializer.fromJson<String>(json['primaryText']),
      type: serializer.fromJson<VocabType>(json['type']),
      notes: serializer.fromJson<String>(json['notes']),
      level: serializer.fromJson<int>(json['level']),
      nextReview: serializer.fromJson<DateTime>(json['nextReview']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      totalCorrectTimes: serializer.fromJson<int>(json['totalCorrectTimes']),
      totalWrongTimes: serializer.fromJson<int>(json['totalWrongTimes']),
      correctTimesCounter:
          serializer.fromJson<int>(json['correctTimesCounter']),
      wrongTimesCounter: serializer.fromJson<int>(json['wrongTimesCounter']),
      lastReview: serializer.fromJson<DateTime?>(json['lastReview']),
      word: serializer.fromJson<String?>(json['word']),
      wordReadings: serializer.fromJson<List<String>?>(json['wordReadings']),
      wordMeanings: serializer.fromJson<List<String>?>(json['wordMeanings']),
      sentence: serializer.fromJson<String?>(json['sentence']),
      answer: serializer.fromJson<String?>(json['answer']),
      timeWord: serializer.fromJson<String?>(json['timeWord']),
      timeReadings: serializer.fromJson<List<String>?>(json['timeReadings']),
      timeString: serializer.fromJson<String?>(json['timeString']),
      verbPlain: serializer.fromJson<VerbForm?>(json['verbPlain']),
      verbForms:
          serializer.fromJson<HashMap<String, VerbForm>?>(json['verbForms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'primaryText': serializer.toJson<String>(primaryText),
      'type': serializer.toJson<VocabType>(type),
      'notes': serializer.toJson<String>(notes),
      'level': serializer.toJson<int>(level),
      'nextReview': serializer.toJson<DateTime>(nextReview),
      'isNew': serializer.toJson<bool>(isNew),
      'totalCorrectTimes': serializer.toJson<int>(totalCorrectTimes),
      'totalWrongTimes': serializer.toJson<int>(totalWrongTimes),
      'correctTimesCounter': serializer.toJson<int>(correctTimesCounter),
      'wrongTimesCounter': serializer.toJson<int>(wrongTimesCounter),
      'lastReview': serializer.toJson<DateTime?>(lastReview),
      'word': serializer.toJson<String?>(word),
      'wordReadings': serializer.toJson<List<String>?>(wordReadings),
      'wordMeanings': serializer.toJson<List<String>?>(wordMeanings),
      'sentence': serializer.toJson<String?>(sentence),
      'answer': serializer.toJson<String?>(answer),
      'timeWord': serializer.toJson<String?>(timeWord),
      'timeReadings': serializer.toJson<List<String>?>(timeReadings),
      'timeString': serializer.toJson<String?>(timeString),
      'verbPlain': serializer.toJson<VerbForm?>(verbPlain),
      'verbForms': serializer.toJson<HashMap<String, VerbForm>?>(verbForms),
    };
  }

  VocabEntry copyWith(
          {int? id,
          String? primaryText,
          VocabType? type,
          String? notes,
          int? level,
          DateTime? nextReview,
          bool? isNew,
          int? totalCorrectTimes,
          int? totalWrongTimes,
          int? correctTimesCounter,
          int? wrongTimesCounter,
          Value<DateTime?> lastReview = const Value.absent(),
          Value<String?> word = const Value.absent(),
          Value<List<String>?> wordReadings = const Value.absent(),
          Value<List<String>?> wordMeanings = const Value.absent(),
          Value<String?> sentence = const Value.absent(),
          Value<String?> answer = const Value.absent(),
          Value<String?> timeWord = const Value.absent(),
          Value<List<String>?> timeReadings = const Value.absent(),
          Value<String?> timeString = const Value.absent(),
          Value<VerbForm?> verbPlain = const Value.absent(),
          Value<HashMap<String, VerbForm>?> verbForms =
              const Value.absent()}) =>
      VocabEntry(
        id: id ?? this.id,
        primaryText: primaryText ?? this.primaryText,
        type: type ?? this.type,
        notes: notes ?? this.notes,
        level: level ?? this.level,
        nextReview: nextReview ?? this.nextReview,
        isNew: isNew ?? this.isNew,
        totalCorrectTimes: totalCorrectTimes ?? this.totalCorrectTimes,
        totalWrongTimes: totalWrongTimes ?? this.totalWrongTimes,
        correctTimesCounter: correctTimesCounter ?? this.correctTimesCounter,
        wrongTimesCounter: wrongTimesCounter ?? this.wrongTimesCounter,
        lastReview: lastReview.present ? lastReview.value : this.lastReview,
        word: word.present ? word.value : this.word,
        wordReadings:
            wordReadings.present ? wordReadings.value : this.wordReadings,
        wordMeanings:
            wordMeanings.present ? wordMeanings.value : this.wordMeanings,
        sentence: sentence.present ? sentence.value : this.sentence,
        answer: answer.present ? answer.value : this.answer,
        timeWord: timeWord.present ? timeWord.value : this.timeWord,
        timeReadings:
            timeReadings.present ? timeReadings.value : this.timeReadings,
        timeString: timeString.present ? timeString.value : this.timeString,
        verbPlain: verbPlain.present ? verbPlain.value : this.verbPlain,
        verbForms: verbForms.present ? verbForms.value : this.verbForms,
      );
  VocabEntry copyWithCompanion(VocabsCompanion data) {
    return VocabEntry(
      id: data.id.present ? data.id.value : this.id,
      primaryText:
          data.primaryText.present ? data.primaryText.value : this.primaryText,
      type: data.type.present ? data.type.value : this.type,
      notes: data.notes.present ? data.notes.value : this.notes,
      level: data.level.present ? data.level.value : this.level,
      nextReview:
          data.nextReview.present ? data.nextReview.value : this.nextReview,
      isNew: data.isNew.present ? data.isNew.value : this.isNew,
      totalCorrectTimes: data.totalCorrectTimes.present
          ? data.totalCorrectTimes.value
          : this.totalCorrectTimes,
      totalWrongTimes: data.totalWrongTimes.present
          ? data.totalWrongTimes.value
          : this.totalWrongTimes,
      correctTimesCounter: data.correctTimesCounter.present
          ? data.correctTimesCounter.value
          : this.correctTimesCounter,
      wrongTimesCounter: data.wrongTimesCounter.present
          ? data.wrongTimesCounter.value
          : this.wrongTimesCounter,
      lastReview:
          data.lastReview.present ? data.lastReview.value : this.lastReview,
      word: data.word.present ? data.word.value : this.word,
      wordReadings: data.wordReadings.present
          ? data.wordReadings.value
          : this.wordReadings,
      wordMeanings: data.wordMeanings.present
          ? data.wordMeanings.value
          : this.wordMeanings,
      sentence: data.sentence.present ? data.sentence.value : this.sentence,
      answer: data.answer.present ? data.answer.value : this.answer,
      timeWord: data.timeWord.present ? data.timeWord.value : this.timeWord,
      timeReadings: data.timeReadings.present
          ? data.timeReadings.value
          : this.timeReadings,
      timeString:
          data.timeString.present ? data.timeString.value : this.timeString,
      verbPlain: data.verbPlain.present ? data.verbPlain.value : this.verbPlain,
      verbForms: data.verbForms.present ? data.verbForms.value : this.verbForms,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabEntry(')
          ..write('id: $id, ')
          ..write('primaryText: $primaryText, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('level: $level, ')
          ..write('nextReview: $nextReview, ')
          ..write('isNew: $isNew, ')
          ..write('totalCorrectTimes: $totalCorrectTimes, ')
          ..write('totalWrongTimes: $totalWrongTimes, ')
          ..write('correctTimesCounter: $correctTimesCounter, ')
          ..write('wrongTimesCounter: $wrongTimesCounter, ')
          ..write('lastReview: $lastReview, ')
          ..write('word: $word, ')
          ..write('wordReadings: $wordReadings, ')
          ..write('wordMeanings: $wordMeanings, ')
          ..write('sentence: $sentence, ')
          ..write('answer: $answer, ')
          ..write('timeWord: $timeWord, ')
          ..write('timeReadings: $timeReadings, ')
          ..write('timeString: $timeString, ')
          ..write('verbPlain: $verbPlain, ')
          ..write('verbForms: $verbForms')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        primaryText,
        type,
        notes,
        level,
        nextReview,
        isNew,
        totalCorrectTimes,
        totalWrongTimes,
        correctTimesCounter,
        wrongTimesCounter,
        lastReview,
        word,
        wordReadings,
        wordMeanings,
        sentence,
        answer,
        timeWord,
        timeReadings,
        timeString,
        verbPlain,
        verbForms
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabEntry &&
          other.id == this.id &&
          other.primaryText == this.primaryText &&
          other.type == this.type &&
          other.notes == this.notes &&
          other.level == this.level &&
          other.nextReview == this.nextReview &&
          other.isNew == this.isNew &&
          other.totalCorrectTimes == this.totalCorrectTimes &&
          other.totalWrongTimes == this.totalWrongTimes &&
          other.correctTimesCounter == this.correctTimesCounter &&
          other.wrongTimesCounter == this.wrongTimesCounter &&
          other.lastReview == this.lastReview &&
          other.word == this.word &&
          other.wordReadings == this.wordReadings &&
          other.wordMeanings == this.wordMeanings &&
          other.sentence == this.sentence &&
          other.answer == this.answer &&
          other.timeWord == this.timeWord &&
          other.timeReadings == this.timeReadings &&
          other.timeString == this.timeString &&
          other.verbPlain == this.verbPlain &&
          other.verbForms == this.verbForms);
}

class VocabsCompanion extends UpdateCompanion<VocabEntry> {
  final Value<int> id;
  final Value<String> primaryText;
  final Value<VocabType> type;
  final Value<String> notes;
  final Value<int> level;
  final Value<DateTime> nextReview;
  final Value<bool> isNew;
  final Value<int> totalCorrectTimes;
  final Value<int> totalWrongTimes;
  final Value<int> correctTimesCounter;
  final Value<int> wrongTimesCounter;
  final Value<DateTime?> lastReview;
  final Value<String?> word;
  final Value<List<String>?> wordReadings;
  final Value<List<String>?> wordMeanings;
  final Value<String?> sentence;
  final Value<String?> answer;
  final Value<String?> timeWord;
  final Value<List<String>?> timeReadings;
  final Value<String?> timeString;
  final Value<VerbForm?> verbPlain;
  final Value<HashMap<String, VerbForm>?> verbForms;
  const VocabsCompanion({
    this.id = const Value.absent(),
    this.primaryText = const Value.absent(),
    this.type = const Value.absent(),
    this.notes = const Value.absent(),
    this.level = const Value.absent(),
    this.nextReview = const Value.absent(),
    this.isNew = const Value.absent(),
    this.totalCorrectTimes = const Value.absent(),
    this.totalWrongTimes = const Value.absent(),
    this.correctTimesCounter = const Value.absent(),
    this.wrongTimesCounter = const Value.absent(),
    this.lastReview = const Value.absent(),
    this.word = const Value.absent(),
    this.wordReadings = const Value.absent(),
    this.wordMeanings = const Value.absent(),
    this.sentence = const Value.absent(),
    this.answer = const Value.absent(),
    this.timeWord = const Value.absent(),
    this.timeReadings = const Value.absent(),
    this.timeString = const Value.absent(),
    this.verbPlain = const Value.absent(),
    this.verbForms = const Value.absent(),
  });
  VocabsCompanion.insert({
    this.id = const Value.absent(),
    required String primaryText,
    required VocabType type,
    required String notes,
    required int level,
    required DateTime nextReview,
    required bool isNew,
    required int totalCorrectTimes,
    required int totalWrongTimes,
    required int correctTimesCounter,
    required int wrongTimesCounter,
    this.lastReview = const Value.absent(),
    this.word = const Value.absent(),
    this.wordReadings = const Value.absent(),
    this.wordMeanings = const Value.absent(),
    this.sentence = const Value.absent(),
    this.answer = const Value.absent(),
    this.timeWord = const Value.absent(),
    this.timeReadings = const Value.absent(),
    this.timeString = const Value.absent(),
    this.verbPlain = const Value.absent(),
    this.verbForms = const Value.absent(),
  })  : primaryText = Value(primaryText),
        type = Value(type),
        notes = Value(notes),
        level = Value(level),
        nextReview = Value(nextReview),
        isNew = Value(isNew),
        totalCorrectTimes = Value(totalCorrectTimes),
        totalWrongTimes = Value(totalWrongTimes),
        correctTimesCounter = Value(correctTimesCounter),
        wrongTimesCounter = Value(wrongTimesCounter);
  static Insertable<VocabEntry> custom({
    Expression<int>? id,
    Expression<String>? primaryText,
    Expression<String>? type,
    Expression<String>? notes,
    Expression<int>? level,
    Expression<DateTime>? nextReview,
    Expression<bool>? isNew,
    Expression<int>? totalCorrectTimes,
    Expression<int>? totalWrongTimes,
    Expression<int>? correctTimesCounter,
    Expression<int>? wrongTimesCounter,
    Expression<DateTime>? lastReview,
    Expression<String>? word,
    Expression<String>? wordReadings,
    Expression<String>? wordMeanings,
    Expression<String>? sentence,
    Expression<String>? answer,
    Expression<String>? timeWord,
    Expression<String>? timeReadings,
    Expression<String>? timeString,
    Expression<String>? verbPlain,
    Expression<String>? verbForms,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (primaryText != null) 'primary_text': primaryText,
      if (type != null) 'type': type,
      if (notes != null) 'notes': notes,
      if (level != null) 'level': level,
      if (nextReview != null) 'next_review': nextReview,
      if (isNew != null) 'is_new': isNew,
      if (totalCorrectTimes != null) 'total_correct_times': totalCorrectTimes,
      if (totalWrongTimes != null) 'total_wrong_times': totalWrongTimes,
      if (correctTimesCounter != null)
        'correct_times_counter': correctTimesCounter,
      if (wrongTimesCounter != null) 'wrong_times_counter': wrongTimesCounter,
      if (lastReview != null) 'last_review': lastReview,
      if (word != null) 'word': word,
      if (wordReadings != null) 'word_readings': wordReadings,
      if (wordMeanings != null) 'word_meanings': wordMeanings,
      if (sentence != null) 'sentence': sentence,
      if (answer != null) 'answer': answer,
      if (timeWord != null) 'time_word': timeWord,
      if (timeReadings != null) 'time_readings': timeReadings,
      if (timeString != null) 'time_string': timeString,
      if (verbPlain != null) 'verb_plain': verbPlain,
      if (verbForms != null) 'verb_forms': verbForms,
    });
  }

  VocabsCompanion copyWith(
      {Value<int>? id,
      Value<String>? primaryText,
      Value<VocabType>? type,
      Value<String>? notes,
      Value<int>? level,
      Value<DateTime>? nextReview,
      Value<bool>? isNew,
      Value<int>? totalCorrectTimes,
      Value<int>? totalWrongTimes,
      Value<int>? correctTimesCounter,
      Value<int>? wrongTimesCounter,
      Value<DateTime?>? lastReview,
      Value<String?>? word,
      Value<List<String>?>? wordReadings,
      Value<List<String>?>? wordMeanings,
      Value<String?>? sentence,
      Value<String?>? answer,
      Value<String?>? timeWord,
      Value<List<String>?>? timeReadings,
      Value<String?>? timeString,
      Value<VerbForm?>? verbPlain,
      Value<HashMap<String, VerbForm>?>? verbForms}) {
    return VocabsCompanion(
      id: id ?? this.id,
      primaryText: primaryText ?? this.primaryText,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      level: level ?? this.level,
      nextReview: nextReview ?? this.nextReview,
      isNew: isNew ?? this.isNew,
      totalCorrectTimes: totalCorrectTimes ?? this.totalCorrectTimes,
      totalWrongTimes: totalWrongTimes ?? this.totalWrongTimes,
      correctTimesCounter: correctTimesCounter ?? this.correctTimesCounter,
      wrongTimesCounter: wrongTimesCounter ?? this.wrongTimesCounter,
      lastReview: lastReview ?? this.lastReview,
      word: word ?? this.word,
      wordReadings: wordReadings ?? this.wordReadings,
      wordMeanings: wordMeanings ?? this.wordMeanings,
      sentence: sentence ?? this.sentence,
      answer: answer ?? this.answer,
      timeWord: timeWord ?? this.timeWord,
      timeReadings: timeReadings ?? this.timeReadings,
      timeString: timeString ?? this.timeString,
      verbPlain: verbPlain ?? this.verbPlain,
      verbForms: verbForms ?? this.verbForms,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (primaryText.present) {
      map['primary_text'] = Variable<String>(primaryText.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($VocabsTable.$convertertype.toSql(type.value));
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (nextReview.present) {
      map['next_review'] = Variable<DateTime>(nextReview.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    if (totalCorrectTimes.present) {
      map['total_correct_times'] = Variable<int>(totalCorrectTimes.value);
    }
    if (totalWrongTimes.present) {
      map['total_wrong_times'] = Variable<int>(totalWrongTimes.value);
    }
    if (correctTimesCounter.present) {
      map['correct_times_counter'] = Variable<int>(correctTimesCounter.value);
    }
    if (wrongTimesCounter.present) {
      map['wrong_times_counter'] = Variable<int>(wrongTimesCounter.value);
    }
    if (lastReview.present) {
      map['last_review'] = Variable<DateTime>(lastReview.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (wordReadings.present) {
      map['word_readings'] = Variable<String>(
          $VocabsTable.$converterwordReadingsn.toSql(wordReadings.value));
    }
    if (wordMeanings.present) {
      map['word_meanings'] = Variable<String>(
          $VocabsTable.$converterwordMeaningsn.toSql(wordMeanings.value));
    }
    if (sentence.present) {
      map['sentence'] = Variable<String>(sentence.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (timeWord.present) {
      map['time_word'] = Variable<String>(timeWord.value);
    }
    if (timeReadings.present) {
      map['time_readings'] = Variable<String>(
          $VocabsTable.$convertertimeReadingsn.toSql(timeReadings.value));
    }
    if (timeString.present) {
      map['time_string'] = Variable<String>(timeString.value);
    }
    if (verbPlain.present) {
      map['verb_plain'] = Variable<String>(
          $VocabsTable.$converterverbPlainn.toSql(verbPlain.value));
    }
    if (verbForms.present) {
      map['verb_forms'] = Variable<String>(
          $VocabsTable.$converterverbFormsn.toSql(verbForms.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabsCompanion(')
          ..write('id: $id, ')
          ..write('primaryText: $primaryText, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('level: $level, ')
          ..write('nextReview: $nextReview, ')
          ..write('isNew: $isNew, ')
          ..write('totalCorrectTimes: $totalCorrectTimes, ')
          ..write('totalWrongTimes: $totalWrongTimes, ')
          ..write('correctTimesCounter: $correctTimesCounter, ')
          ..write('wrongTimesCounter: $wrongTimesCounter, ')
          ..write('lastReview: $lastReview, ')
          ..write('word: $word, ')
          ..write('wordReadings: $wordReadings, ')
          ..write('wordMeanings: $wordMeanings, ')
          ..write('sentence: $sentence, ')
          ..write('answer: $answer, ')
          ..write('timeWord: $timeWord, ')
          ..write('timeReadings: $timeReadings, ')
          ..write('timeString: $timeString, ')
          ..write('verbPlain: $verbPlain, ')
          ..write('verbForms: $verbForms')
          ..write(')'))
        .toString();
  }
}

class $KeyValueStoreTable extends KeyValueStore
    with TableInfo<$KeyValueStoreTable, KeyValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyValueStoreTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'key_value_store';
  @override
  VerificationContext validateIntegrity(Insertable<KeyValue> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KeyValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeyValue(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $KeyValueStoreTable createAlias(String alias) {
    return $KeyValueStoreTable(attachedDatabase, alias);
  }
}

class KeyValue extends DataClass implements Insertable<KeyValue> {
  final String key;
  final String value;
  const KeyValue({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  KeyValueStoreCompanion toCompanion(bool nullToAbsent) {
    return KeyValueStoreCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory KeyValue.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeyValue(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  KeyValue copyWith({String? key, String? value}) => KeyValue(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  KeyValue copyWithCompanion(KeyValueStoreCompanion data) {
    return KeyValue(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeyValue(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeyValue && other.key == this.key && other.value == this.value);
}

class KeyValueStoreCompanion extends UpdateCompanion<KeyValue> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const KeyValueStoreCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeyValueStoreCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<KeyValue> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeyValueStoreCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return KeyValueStoreCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyValueStoreCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyDueCacheTable extends DailyDueCache
    with TableInfo<$DailyDueCacheTable, DueCache> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyDueCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vocabIdMeta =
      const VerificationMeta('vocabId');
  @override
  late final GeneratedColumn<int> vocabId = GeneratedColumn<int>(
      'vocab_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [vocabId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_due_cache';
  @override
  VerificationContext validateIntegrity(Insertable<DueCache> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vocab_id')) {
      context.handle(_vocabIdMeta,
          vocabId.isAcceptableOrUnknown(data['vocab_id']!, _vocabIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vocabId};
  @override
  DueCache map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DueCache(
      vocabId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vocab_id'])!,
    );
  }

  @override
  $DailyDueCacheTable createAlias(String alias) {
    return $DailyDueCacheTable(attachedDatabase, alias);
  }
}

class DueCache extends DataClass implements Insertable<DueCache> {
  final int vocabId;
  const DueCache({required this.vocabId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vocab_id'] = Variable<int>(vocabId);
    return map;
  }

  DailyDueCacheCompanion toCompanion(bool nullToAbsent) {
    return DailyDueCacheCompanion(
      vocabId: Value(vocabId),
    );
  }

  factory DueCache.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DueCache(
      vocabId: serializer.fromJson<int>(json['vocabId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vocabId': serializer.toJson<int>(vocabId),
    };
  }

  DueCache copyWith({int? vocabId}) => DueCache(
        vocabId: vocabId ?? this.vocabId,
      );
  DueCache copyWithCompanion(DailyDueCacheCompanion data) {
    return DueCache(
      vocabId: data.vocabId.present ? data.vocabId.value : this.vocabId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DueCache(')
          ..write('vocabId: $vocabId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => vocabId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DueCache && other.vocabId == this.vocabId);
}

class DailyDueCacheCompanion extends UpdateCompanion<DueCache> {
  final Value<int> vocabId;
  const DailyDueCacheCompanion({
    this.vocabId = const Value.absent(),
  });
  DailyDueCacheCompanion.insert({
    this.vocabId = const Value.absent(),
  });
  static Insertable<DueCache> custom({
    Expression<int>? vocabId,
  }) {
    return RawValuesInsertable({
      if (vocabId != null) 'vocab_id': vocabId,
    });
  }

  DailyDueCacheCompanion copyWith({Value<int>? vocabId}) {
    return DailyDueCacheCompanion(
      vocabId: vocabId ?? this.vocabId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vocabId.present) {
      map['vocab_id'] = Variable<int>(vocabId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyDueCacheCompanion(')
          ..write('vocabId: $vocabId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VocabsTable vocabs = $VocabsTable(this);
  late final $KeyValueStoreTable keyValueStore = $KeyValueStoreTable(this);
  late final $DailyDueCacheTable dailyDueCache = $DailyDueCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [vocabs, keyValueStore, dailyDueCache];
}

typedef $$VocabsTableCreateCompanionBuilder = VocabsCompanion Function({
  Value<int> id,
  required String primaryText,
  required VocabType type,
  required String notes,
  required int level,
  required DateTime nextReview,
  required bool isNew,
  required int totalCorrectTimes,
  required int totalWrongTimes,
  required int correctTimesCounter,
  required int wrongTimesCounter,
  Value<DateTime?> lastReview,
  Value<String?> word,
  Value<List<String>?> wordReadings,
  Value<List<String>?> wordMeanings,
  Value<String?> sentence,
  Value<String?> answer,
  Value<String?> timeWord,
  Value<List<String>?> timeReadings,
  Value<String?> timeString,
  Value<VerbForm?> verbPlain,
  Value<HashMap<String, VerbForm>?> verbForms,
});
typedef $$VocabsTableUpdateCompanionBuilder = VocabsCompanion Function({
  Value<int> id,
  Value<String> primaryText,
  Value<VocabType> type,
  Value<String> notes,
  Value<int> level,
  Value<DateTime> nextReview,
  Value<bool> isNew,
  Value<int> totalCorrectTimes,
  Value<int> totalWrongTimes,
  Value<int> correctTimesCounter,
  Value<int> wrongTimesCounter,
  Value<DateTime?> lastReview,
  Value<String?> word,
  Value<List<String>?> wordReadings,
  Value<List<String>?> wordMeanings,
  Value<String?> sentence,
  Value<String?> answer,
  Value<String?> timeWord,
  Value<List<String>?> timeReadings,
  Value<String?> timeString,
  Value<VerbForm?> verbPlain,
  Value<HashMap<String, VerbForm>?> verbForms,
});

class $$VocabsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabsTable> {
  $$VocabsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryText => $composableBuilder(
      column: $table.primaryText, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<VocabType, VocabType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReview => $composableBuilder(
      column: $table.nextReview, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isNew => $composableBuilder(
      column: $table.isNew, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCorrectTimes => $composableBuilder(
      column: $table.totalCorrectTimes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalWrongTimes => $composableBuilder(
      column: $table.totalWrongTimes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctTimesCounter => $composableBuilder(
      column: $table.correctTimesCounter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wrongTimesCounter => $composableBuilder(
      column: $table.wrongTimesCounter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReview => $composableBuilder(
      column: $table.lastReview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get wordReadings => $composableBuilder(
          column: $table.wordReadings,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get wordMeanings => $composableBuilder(
          column: $table.wordMeanings,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get sentence => $composableBuilder(
      column: $table.sentence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeWord => $composableBuilder(
      column: $table.timeWord, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get timeReadings => $composableBuilder(
          column: $table.timeReadings,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get timeString => $composableBuilder(
      column: $table.timeString, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<VerbForm?, VerbForm, String> get verbPlain =>
      $composableBuilder(
          column: $table.verbPlain,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<HashMap<String, VerbForm>?,
          HashMap<String, VerbForm>, String>
      get verbForms => $composableBuilder(
          column: $table.verbForms,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$VocabsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabsTable> {
  $$VocabsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryText => $composableBuilder(
      column: $table.primaryText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReview => $composableBuilder(
      column: $table.nextReview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isNew => $composableBuilder(
      column: $table.isNew, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCorrectTimes => $composableBuilder(
      column: $table.totalCorrectTimes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalWrongTimes => $composableBuilder(
      column: $table.totalWrongTimes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctTimesCounter => $composableBuilder(
      column: $table.correctTimesCounter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wrongTimesCounter => $composableBuilder(
      column: $table.wrongTimesCounter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReview => $composableBuilder(
      column: $table.lastReview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wordReadings => $composableBuilder(
      column: $table.wordReadings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wordMeanings => $composableBuilder(
      column: $table.wordMeanings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sentence => $composableBuilder(
      column: $table.sentence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeWord => $composableBuilder(
      column: $table.timeWord, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeReadings => $composableBuilder(
      column: $table.timeReadings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeString => $composableBuilder(
      column: $table.timeString, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verbPlain => $composableBuilder(
      column: $table.verbPlain, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verbForms => $composableBuilder(
      column: $table.verbForms, builder: (column) => ColumnOrderings(column));
}

class $$VocabsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabsTable> {
  $$VocabsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get primaryText => $composableBuilder(
      column: $table.primaryText, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VocabType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReview => $composableBuilder(
      column: $table.nextReview, builder: (column) => column);

  GeneratedColumn<bool> get isNew =>
      $composableBuilder(column: $table.isNew, builder: (column) => column);

  GeneratedColumn<int> get totalCorrectTimes => $composableBuilder(
      column: $table.totalCorrectTimes, builder: (column) => column);

  GeneratedColumn<int> get totalWrongTimes => $composableBuilder(
      column: $table.totalWrongTimes, builder: (column) => column);

  GeneratedColumn<int> get correctTimesCounter => $composableBuilder(
      column: $table.correctTimesCounter, builder: (column) => column);

  GeneratedColumn<int> get wrongTimesCounter => $composableBuilder(
      column: $table.wrongTimesCounter, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReview => $composableBuilder(
      column: $table.lastReview, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get wordReadings =>
      $composableBuilder(
          column: $table.wordReadings, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get wordMeanings =>
      $composableBuilder(
          column: $table.wordMeanings, builder: (column) => column);

  GeneratedColumn<String> get sentence =>
      $composableBuilder(column: $table.sentence, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get timeWord =>
      $composableBuilder(column: $table.timeWord, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get timeReadings =>
      $composableBuilder(
          column: $table.timeReadings, builder: (column) => column);

  GeneratedColumn<String> get timeString => $composableBuilder(
      column: $table.timeString, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VerbForm?, String> get verbPlain =>
      $composableBuilder(column: $table.verbPlain, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HashMap<String, VerbForm>?, String>
      get verbForms => $composableBuilder(
          column: $table.verbForms, builder: (column) => column);
}

class $$VocabsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VocabsTable,
    VocabEntry,
    $$VocabsTableFilterComposer,
    $$VocabsTableOrderingComposer,
    $$VocabsTableAnnotationComposer,
    $$VocabsTableCreateCompanionBuilder,
    $$VocabsTableUpdateCompanionBuilder,
    (VocabEntry, BaseReferences<_$AppDatabase, $VocabsTable, VocabEntry>),
    VocabEntry,
    PrefetchHooks Function()> {
  $$VocabsTableTableManager(_$AppDatabase db, $VocabsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> primaryText = const Value.absent(),
            Value<VocabType> type = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<DateTime> nextReview = const Value.absent(),
            Value<bool> isNew = const Value.absent(),
            Value<int> totalCorrectTimes = const Value.absent(),
            Value<int> totalWrongTimes = const Value.absent(),
            Value<int> correctTimesCounter = const Value.absent(),
            Value<int> wrongTimesCounter = const Value.absent(),
            Value<DateTime?> lastReview = const Value.absent(),
            Value<String?> word = const Value.absent(),
            Value<List<String>?> wordReadings = const Value.absent(),
            Value<List<String>?> wordMeanings = const Value.absent(),
            Value<String?> sentence = const Value.absent(),
            Value<String?> answer = const Value.absent(),
            Value<String?> timeWord = const Value.absent(),
            Value<List<String>?> timeReadings = const Value.absent(),
            Value<String?> timeString = const Value.absent(),
            Value<VerbForm?> verbPlain = const Value.absent(),
            Value<HashMap<String, VerbForm>?> verbForms = const Value.absent(),
          }) =>
              VocabsCompanion(
            id: id,
            primaryText: primaryText,
            type: type,
            notes: notes,
            level: level,
            nextReview: nextReview,
            isNew: isNew,
            totalCorrectTimes: totalCorrectTimes,
            totalWrongTimes: totalWrongTimes,
            correctTimesCounter: correctTimesCounter,
            wrongTimesCounter: wrongTimesCounter,
            lastReview: lastReview,
            word: word,
            wordReadings: wordReadings,
            wordMeanings: wordMeanings,
            sentence: sentence,
            answer: answer,
            timeWord: timeWord,
            timeReadings: timeReadings,
            timeString: timeString,
            verbPlain: verbPlain,
            verbForms: verbForms,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String primaryText,
            required VocabType type,
            required String notes,
            required int level,
            required DateTime nextReview,
            required bool isNew,
            required int totalCorrectTimes,
            required int totalWrongTimes,
            required int correctTimesCounter,
            required int wrongTimesCounter,
            Value<DateTime?> lastReview = const Value.absent(),
            Value<String?> word = const Value.absent(),
            Value<List<String>?> wordReadings = const Value.absent(),
            Value<List<String>?> wordMeanings = const Value.absent(),
            Value<String?> sentence = const Value.absent(),
            Value<String?> answer = const Value.absent(),
            Value<String?> timeWord = const Value.absent(),
            Value<List<String>?> timeReadings = const Value.absent(),
            Value<String?> timeString = const Value.absent(),
            Value<VerbForm?> verbPlain = const Value.absent(),
            Value<HashMap<String, VerbForm>?> verbForms = const Value.absent(),
          }) =>
              VocabsCompanion.insert(
            id: id,
            primaryText: primaryText,
            type: type,
            notes: notes,
            level: level,
            nextReview: nextReview,
            isNew: isNew,
            totalCorrectTimes: totalCorrectTimes,
            totalWrongTimes: totalWrongTimes,
            correctTimesCounter: correctTimesCounter,
            wrongTimesCounter: wrongTimesCounter,
            lastReview: lastReview,
            word: word,
            wordReadings: wordReadings,
            wordMeanings: wordMeanings,
            sentence: sentence,
            answer: answer,
            timeWord: timeWord,
            timeReadings: timeReadings,
            timeString: timeString,
            verbPlain: verbPlain,
            verbForms: verbForms,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VocabsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VocabsTable,
    VocabEntry,
    $$VocabsTableFilterComposer,
    $$VocabsTableOrderingComposer,
    $$VocabsTableAnnotationComposer,
    $$VocabsTableCreateCompanionBuilder,
    $$VocabsTableUpdateCompanionBuilder,
    (VocabEntry, BaseReferences<_$AppDatabase, $VocabsTable, VocabEntry>),
    VocabEntry,
    PrefetchHooks Function()>;
typedef $$KeyValueStoreTableCreateCompanionBuilder = KeyValueStoreCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$KeyValueStoreTableUpdateCompanionBuilder = KeyValueStoreCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$KeyValueStoreTableFilterComposer
    extends Composer<_$AppDatabase, $KeyValueStoreTable> {
  $$KeyValueStoreTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$KeyValueStoreTableOrderingComposer
    extends Composer<_$AppDatabase, $KeyValueStoreTable> {
  $$KeyValueStoreTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$KeyValueStoreTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeyValueStoreTable> {
  $$KeyValueStoreTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$KeyValueStoreTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KeyValueStoreTable,
    KeyValue,
    $$KeyValueStoreTableFilterComposer,
    $$KeyValueStoreTableOrderingComposer,
    $$KeyValueStoreTableAnnotationComposer,
    $$KeyValueStoreTableCreateCompanionBuilder,
    $$KeyValueStoreTableUpdateCompanionBuilder,
    (KeyValue, BaseReferences<_$AppDatabase, $KeyValueStoreTable, KeyValue>),
    KeyValue,
    PrefetchHooks Function()> {
  $$KeyValueStoreTableTableManager(_$AppDatabase db, $KeyValueStoreTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeyValueStoreTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeyValueStoreTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeyValueStoreTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KeyValueStoreCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              KeyValueStoreCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KeyValueStoreTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KeyValueStoreTable,
    KeyValue,
    $$KeyValueStoreTableFilterComposer,
    $$KeyValueStoreTableOrderingComposer,
    $$KeyValueStoreTableAnnotationComposer,
    $$KeyValueStoreTableCreateCompanionBuilder,
    $$KeyValueStoreTableUpdateCompanionBuilder,
    (KeyValue, BaseReferences<_$AppDatabase, $KeyValueStoreTable, KeyValue>),
    KeyValue,
    PrefetchHooks Function()>;
typedef $$DailyDueCacheTableCreateCompanionBuilder = DailyDueCacheCompanion
    Function({
  Value<int> vocabId,
});
typedef $$DailyDueCacheTableUpdateCompanionBuilder = DailyDueCacheCompanion
    Function({
  Value<int> vocabId,
});

class $$DailyDueCacheTableFilterComposer
    extends Composer<_$AppDatabase, $DailyDueCacheTable> {
  $$DailyDueCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get vocabId => $composableBuilder(
      column: $table.vocabId, builder: (column) => ColumnFilters(column));
}

class $$DailyDueCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyDueCacheTable> {
  $$DailyDueCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get vocabId => $composableBuilder(
      column: $table.vocabId, builder: (column) => ColumnOrderings(column));
}

class $$DailyDueCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyDueCacheTable> {
  $$DailyDueCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get vocabId =>
      $composableBuilder(column: $table.vocabId, builder: (column) => column);
}

class $$DailyDueCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyDueCacheTable,
    DueCache,
    $$DailyDueCacheTableFilterComposer,
    $$DailyDueCacheTableOrderingComposer,
    $$DailyDueCacheTableAnnotationComposer,
    $$DailyDueCacheTableCreateCompanionBuilder,
    $$DailyDueCacheTableUpdateCompanionBuilder,
    (DueCache, BaseReferences<_$AppDatabase, $DailyDueCacheTable, DueCache>),
    DueCache,
    PrefetchHooks Function()> {
  $$DailyDueCacheTableTableManager(_$AppDatabase db, $DailyDueCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyDueCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyDueCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyDueCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> vocabId = const Value.absent(),
          }) =>
              DailyDueCacheCompanion(
            vocabId: vocabId,
          ),
          createCompanionCallback: ({
            Value<int> vocabId = const Value.absent(),
          }) =>
              DailyDueCacheCompanion.insert(
            vocabId: vocabId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyDueCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyDueCacheTable,
    DueCache,
    $$DailyDueCacheTableFilterComposer,
    $$DailyDueCacheTableOrderingComposer,
    $$DailyDueCacheTableAnnotationComposer,
    $$DailyDueCacheTableCreateCompanionBuilder,
    $$DailyDueCacheTableUpdateCompanionBuilder,
    (DueCache, BaseReferences<_$AppDatabase, $DailyDueCacheTable, DueCache>),
    DueCache,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VocabsTableTableManager get vocabs =>
      $$VocabsTableTableManager(_db, _db.vocabs);
  $$KeyValueStoreTableTableManager get keyValueStore =>
      $$KeyValueStoreTableTableManager(_db, _db.keyValueStore);
  $$DailyDueCacheTableTableManager get dailyDueCache =>
      $$DailyDueCacheTableTableManager(_db, _db.dailyDueCache);
}
