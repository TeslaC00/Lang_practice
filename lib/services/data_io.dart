import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lang_practice/models/vocab.dart';
import 'package:lang_practice/models/vocab_meta.dart';
import 'package:lang_practice/services/database.dart';
import 'package:lang_practice/vocab_mapper.dart';
import 'package:lang_practice/services/logger_service.dart'; // Added import
import 'package:path_provider/path_provider.dart';

import 'package:drift/drift.dart' as drift;

Future<List<Vocab>> _parseVocabs(String jsonString) async {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList
      .map((json) => Vocab.fromJson(json as Map<String, dynamic>))
      .toList();
}

void _showProgressSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(minutes: 5), // long enough for import/export
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 10),
          const LinearProgressIndicator(),
        ],
      ),
    ),
  );
}

void _hideProgressSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

Future<void> importData(BuildContext context) async {
  LoggerService().d("importData entry"); // Added log
  // Pick File from Device
  try {
    _showProgressSnackBar(context, "Importing data...");

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    // User canceled the picker
    if (result == null) {
      LoggerService().i("Import cancelled by user."); // Added log
      return;
    }

    // Convert to JSON
    LoggerService().i(
      "Attempting to import data from ${result.files.single.path}",
    ); // Added log
    final bytes = result.files.single.bytes;
    final jsonString = bytes != null
        ? utf8.decode(bytes)
        : await File(result.files.single.path!).readAsString();

    final vocabs = await compute(_parseVocabs, jsonString);

    // Save to Database
    final db = AppDatabase.instance;

    // 1. Get count BEFORE
    final countQuery = db.selectOnly(db.vocabs)
      ..addColumns([db.vocabs.id.count()]);
    final countBefore =
        (await countQuery.getSingle()).read(db.vocabs.id.count()) ?? 0;

    // 2. Prepare companions (your existing logic)
    final companions = <VocabsCompanion>[];

    for (final vocab in vocabs) {
      // We need to convert our vocab model to VocabCompanion
      companions.add(VocabMapper.vocabToCompanion(vocab));
    }

    // 3. Run the batch insert (your existing logic)
    await db.batch((batch) {
      batch.insertAll(
        db.vocabs,
        companions,
        mode: drift.InsertMode.insertOrIgnore,
      );
    });

    // 4. Get count AFTER
    final countAfter =
        (await countQuery.getSingle()).read(db.vocabs.id.count()) ?? 0;

    // 5. Calculate the results
    final totalInFile = vocabs.length;
    final itemsAdded = countAfter - countBefore;
    final itemsIgnored = totalInFile - itemsAdded;

    // Clear cache to get review of new data
    // await Hive.box<dynamic>('cacheBox').clear();
    await db.delete(db.dailyDueCache).go();
    await db.delete(db.keyValueStore).go();

    if (context.mounted) _hideProgressSnackBar(context);

    LoggerService().i(
      "Data imported successfully. Added $itemsAdded new vocabs. "
      "Ignored $itemsIgnored duplicates (from $totalInFile total in file).",
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data imported successfully!")),
      );
    }
  } catch (e, s) {
    // Added stackTrace
    LoggerService().e("Import failed", e, s); // Modified log
    if (kDebugMode) print("Import failed: $e");
  }
}

Future<void> exportData(BuildContext context) async {
  LoggerService().d("exportData entry"); // Added log
  try {
    final db = AppDatabase.instance;
    final allEntries = await db.select(db.vocabs).get();

    // convert from Drift VocabEntry to Vocab
    final vocabs = <Vocab>[];
    for (final entry in allEntries) {
      vocabs.add(VocabMapper.entryToVocab(entry));
    }

    // Convert to JSON
    final jsonList = vocabs.map((vocab) => vocab.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    // Convert JSON String to Bytes
    final bytes = Uint8List.fromList(utf8.encode(jsonString));
    final dir = await getApplicationDocumentsDirectory();

    // Pick File to Save
    final filePath = await FilePicker.platform.saveFile(
      dialogTitle: "Please select an output file:",
      fileName: 'backup.json',
      allowedExtensions: ['json'],
      initialDirectory: dir.path,
      bytes: bytes,
    );

    if (filePath == null) {
      LoggerService().i("Export cancelled by user."); // Added log
      return;
    }

    LoggerService().i("Data exported successfully to $filePath"); // Added log

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data exported successfully!")),
      );
    }
  } catch (e, s) {
    // Added stackTrace
    LoggerService().e("Export failed", e, s); // Modified log
    if (kDebugMode) print("Export failed: $e");
  }
}
