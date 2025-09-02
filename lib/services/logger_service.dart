import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  late Logger _logger;
  File? _logFile;

  factory LoggerService() {
    return _instance;
  }

  LoggerService._internal();

  Future<void> init() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    _logFile = File('${documentsDir.path}/app_logs.txt');

    if (!await _logFile!.exists()) {
      await _logFile!.create(recursive: true);
    }

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
      output: MultiOutput([
        ConsoleOutput(),
        if (_logFile != null) FileOutput(file: _logFile!),
      ]),
      filter:
          ProductionFilter(), // Use ProductionFilter to log only info and above in release.
    );

    // To catch Dart zone errors
    Logger.addLogListener((event) async {
      if (event.level.index >= Level.error.index && _logFile != null) {
        // Log error to file
        final logLine =
            '[${DateTime.now()}] ${event.level.name}: ${event.message}\n'
            '${event.error ?? ''}\n'
            '${event.stackTrace ?? ''}\n';

        await _logFile!.writeAsString(
          logLine,
          mode: FileMode.writeOnlyAppend,
          flush: true,
        );
      }
    });
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void t(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  String? get logFilePath => _logFile?.path;

  Future<void> shareLogs() async {
    if (_logFile == null) return;

    final dir = _logFile!.parent;
    final logFiles = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.contains('app_logs'))
        .map((f) => XFile(f.path))
        .toList();

    if (logFiles.isNotEmpty) {
      await SharePlus.instance.share(
        ShareParams(files: logFiles, text: 'App Logs'),
      );
    }
  }
}

// Optional: A simple file output that appends to the file.
class FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding; // Should be Encoding

  FileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding =
        utf8, // Placeholder, should use `Encoding.getByName('utf-8')`
  });

  @override
  Future<void> output(OutputEvent event) async {
    try {
      final mode = overrideExisting
          ? FileMode.writeOnly
          : FileMode.writeOnlyAppend;
      // Using lyu directly in the string might cause issues if the encoding is not handled correctly.
      // It's better to ensure the file is opened with the correct encoding.
      // However, the `logger` package's FileOutput might handle this internally.
      // For simplicity, we'll just write the lines.
      if (await file.length() > 1024 * 1024 * 10) {
        final backup = File(
          '${file.path}.${DateTime.now().millisecondsSinceEpoch}',
        );
        await file.rename(backup.path);
        await file.writeAsString('', mode: FileMode.write); // start fresh

        final dir = file.parent;
        final logFiles = dir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.contains('app_logs.txt'))
            .toList();

        logFiles.sort((a, b) => a.path.compareTo(b.path));

        const maxBackups = 5;
        if (logFiles.length > maxBackups) {
          for (var i = 0; i < logFiles.length - maxBackups; i++) {
            await logFiles[i].delete();
          }
        }
      }

      for (var line in event.lines) {
        await file.writeAsString(
          '$line\n',
          mode: mode,
          flush: true,
          encoding: encoding,
        ); // Basic encoding handling
      }
    } catch (e) {
      // In a real app, consider a fallback logging mechanism or reporting this error.
      if (kDebugMode) print('Failed to write to log file: $e');
    }
  }
}
