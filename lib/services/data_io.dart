import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lang_practice/models/vocab.dart';
import 'package:lang_practice/services/logger_service.dart'; // Added import
import 'package:path_provider/path_provider.dart';

Future<void> exportData(BuildContext context) async {
  LoggerService().d("exportData entry"); // Added log
  final box = await Hive.openBox<Vocab>('vocabBox');
  final vocabs = box.values.toList();

  // Convert to JSON
  try {
    final jsonList = vocabs.map((vocab) => vocab.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    final dir = await getApplicationDocumentsDirectory();

    // Pick File to Save
    String? filePath = await FilePicker.platform.saveFile(
      dialogTitle: "Please select an output file:",
      fileName: 'backup.json',
      allowedExtensions: ['json'],
      initialDirectory: dir.path,
    );

    if (filePath == null) {
      LoggerService().i("Export cancelled by user."); // Added log
      return;
    }

    final file = File(filePath);
    await file.writeAsString(jsonString);
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

Future<void> importData(BuildContext context) async {
  LoggerService().d("importData entry"); // Added log
  // Pick File from Device
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  // User canceled the picker
  if (result == null) {
    LoggerService().i("Import cancelled by user."); // Added log
    return;
  }

  File? file = File(result.files.single.path!);
  if (!file.existsSync()) {
    LoggerService().w("Import file does not exist: ${file.path}"); // Added log
    return;
  }
  LoggerService().i("Attempting to import data from ${file.path}"); // Added log

  // Convert to JSON
  try {
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);

    final List<Vocab> vocabs = jsonList
        .map((json) => Vocab.fromJson(json as Map<String, dynamic>))
        .toList();

    // Save to Database
    final box = await Hive.openBox<Vocab>('vocabBox');
    int newVocabsCount = 0;
    for (final vocab in vocabs) {
      final exists = box.values.any((v) => v == vocab);
      if (!exists) {
        box.add(vocab);
        newVocabsCount++;
      }
    }
    LoggerService().i(
      "Data imported successfully. Added $newVocabsCount new vocabs.",
    ); // Added log

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
