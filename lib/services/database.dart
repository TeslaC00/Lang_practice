import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lang_practice/models/vocab.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart'; // This file will be generated

@DataClassName('VocabEntry')
class Vocabs extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get primaryText => text()();

  // Common Vocab fields
  TextColumn get type => text().map(const VocabTypeConverter())();

  TextColumn get notes => text()();

  // Flattened VocabMeta fields
  IntColumn get level => integer()();

  DateTimeColumn get nextReview => dateTime()();

  BoolColumn get isNew => boolean()();

  IntColumn get totalCorrectTimes => integer()();

  IntColumn get totalWrongTimes => integer()();

  IntColumn get correctTimesCounter => integer()();

  IntColumn get wrongTimesCounter => integer()();

  DateTimeColumn get lastReview => dateTime().nullable()();

  //   WordVocab fields (nullable)
  TextColumn get word => text().nullable()();

  TextColumn get wordReadings => text().map(const ListConverter()).nullable()();

  TextColumn get wordMeanings => text().map(const ListConverter()).nullable()();

  //   SentenceVocab fields (nullable)
  TextColumn get sentence => text().nullable()();

  TextColumn get answer => text().nullable()();

  //   TimeVocab fields (nullable)
  TextColumn get timeWord => text().nullable()();

  TextColumn get timeReadings => text().map(const ListConverter()).nullable()();

  TextColumn get timeString => text().nullable()();

  //   VerbVocab fields (nullable)
  TextColumn get verbPlain =>
      text().map(const VerbFormConverter()).nullable()();

  TextColumn get verbForms => text().map(const VerbMapConverter()).nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {type, primaryText},
  ];
}

@DataClassName('KeyValue')
class KeyValueStore extends Table {
  TextColumn get key => text()();

  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

// This will store the list of IDs for today's review
@DataClassName('DueCache')
class DailyDueCache extends Table {
  IntColumn get vocabId => integer()();

  @override
  Set<Column> get primaryKey => {vocabId};
}

class VocabTypeConverter extends TypeConverter<VocabType, String> {
  const VocabTypeConverter();

  @override
  VocabType fromSql(String fromDb) {
    return VocabType.values.byName(fromDb);
  }

  @override
  String toSql(VocabType value) {
    return value.name;
  }
}

class ListConverter extends TypeConverter<List<String>, String> {
  const ListConverter();

  @override
  List<String> fromSql(String fromDb) {
    return (jsonDecode(fromDb) as List<dynamic>).cast<String>();
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}

class VerbFormConverter extends TypeConverter<VerbForm, String> {
  const VerbFormConverter();

  @override
  VerbForm fromSql(String fromDb) {
    return VerbForm.fromJson(jsonDecode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(VerbForm value) {
    return jsonEncode(value.toJson());
  }
}

class VerbMapConverter extends TypeConverter<Map<String, VerbForm>, String> {
  const VerbMapConverter();

  @override
  Map<String, VerbForm> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return {};
    }
    final decodedMap = jsonDecode(fromDb) as Map<String, dynamic>;
    return decodedMap.map((key, value) {
      return MapEntry(key, VerbForm.fromJson(value as Map<String, dynamic>));
    });
  }

  @override
  String toSql(Map<String, VerbForm> value) {
    final jsonReadyMap = value.map((key, verbForm) {
      return MapEntry(key, verbForm.toJson());
    });
    return jsonEncode(jsonReadyMap);
  }
}

@DriftDatabase(tables: [Vocabs, KeyValueStore, DailyDueCache])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static final AppDatabase instance = AppDatabase();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
