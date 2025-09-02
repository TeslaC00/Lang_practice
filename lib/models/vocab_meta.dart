import 'package:hive/hive.dart';

part 'vocab_meta.g.dart';

@HiveType(typeId: 0) // Ensure this typeId is unique
class VocabMeta extends HiveObject {
  @HiveField(0)
  int level;

  @HiveField(1)
  DateTime nextReview;

  @HiveField(2)
  bool isNew;

  @HiveField(3)
  String notes;

  @HiveField(4)
  int totalCorrectTimes;

  @HiveField(5)
  int totalWrongTimes;

  @HiveField(6)
  int correctTimesCounter; // Consecutive correct answers

  @HiveField(7)
  int wrongTimesCounter; // Consecutive wrong answers (resets correctTimesCounter)

  @HiveField(8)
  DateTime? lastReview;

  VocabMeta({
    this.level = 0,
    DateTime? nextReview,
    this.isNew = true,
    this.notes = '',
    this.totalCorrectTimes = 0,
    this.totalWrongTimes = 0,
    this.correctTimesCounter = 0,
    this.wrongTimesCounter = 0,
    this.lastReview,
  }) : nextReview = nextReview ?? DateTime.now();

  Map<String, dynamic> toJson() =>
      {
        'level': level,
        'nextReview': nextReview.toIso8601String(),
        'isNew': isNew,
        'notes': notes,
        'totalCorrectTimes': totalCorrectTimes,
        'totalWrongTimes': totalWrongTimes,
        'correctTimesCounter': correctTimesCounter,
        'wrongTimesCounter': wrongTimesCounter,
        'lastReview': lastReview?.toIso8601String(),
      };

  static VocabMeta fromJson(Map<String, dynamic> json) {
    return VocabMeta(
      level: json['level'] as int? ?? 0,
      nextReview: json['nextReview'] == null
          ? DateTime.now()
          : DateTime.parse(json['nextReview'] as String),
      isNew: json['isNew'] as bool? ?? true,
      notes: json['notes'] as String? ?? '',
      totalCorrectTimes: json['totalCorrectTimes'] as int? ?? 0,
      totalWrongTimes: json['totalWrongTimes'] as int? ?? 0,
      correctTimesCounter: json['correctTimesCounter'] as int? ?? 0,
      wrongTimesCounter: json['wrongTimesCounter'] as int? ?? 0,
      lastReview: json['lastReview'] == null
          ? null
          : DateTime.parse(json['lastReview'] as String),
    );
  }

  @override
  String toString() {
    return 'VocabMeta{level: $level, nextReview: $nextReview, isNew: $isNew, '
        'notes: $notes, totalCorrect: $totalCorrectTimes, totalWrong: $totalWrongTimes, '
        'correctStreak: $correctTimesCounter, wrongStreak: $wrongTimesCounter, lastReview: $lastReview}';
  }
}
