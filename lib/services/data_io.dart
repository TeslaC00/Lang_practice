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
  try {
    final box = Hive.box<Vocab>('vocabBox');
    final vocabs = box.values.toList();

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
    final box = Hive.box<Vocab>('vocabBox');
    final existing = box.values.toSet();

    final newVocabs = vocabs.where((v) => !existing.contains(v)).toList();

    if (newVocabs.isNotEmpty) box.addAll(newVocabs);
    // Clear cache to get review of new data
    await Hive.box<dynamic>('cacheBox').clear();

    if (context.mounted) _hideProgressSnackBar(context);

    LoggerService().i(
      "Data imported successfully. Added ${newVocabs.length} new vocabs, From ${vocabs.length} total. "
      "Ignore duplicate vocabs ${vocabs.length - newVocabs.length}.",
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
