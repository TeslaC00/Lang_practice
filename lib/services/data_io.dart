import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lang_practice/models/vocab.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportData(BuildContext context) async {
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

    if (filePath == null) return;

    final file = File(filePath);
    await file.writeAsString(jsonString);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data exported successfully!")),
      );
    }
  } catch (e) {
    if (kDebugMode) print("Export failed: $e");
  }
}

Future<void> importData(BuildContext context) async {
  // Pick File from Device
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  // User canceled the picker
  if (result == null) return;

  File? file = File(result.files.single.path!);
  if (!file.existsSync()) return;

  // Convert to JSON
  try {
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);

    final List<Vocab> vocabs = jsonList
        .map((json) => Vocab.fromJson(json as Map<String, dynamic>))
        .toList();

    // Save to Database
    final box = await Hive.openBox<Vocab>('vocabBox');
    for (final vocab in vocabs) {
      final exists = box.values.any((v) => v == vocab);
      if (!exists) box.add(vocab);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data imported successfully!")),
      );
    }
  } catch (e) {
    if (kDebugMode) print("Import failed: $e");
  }
}
