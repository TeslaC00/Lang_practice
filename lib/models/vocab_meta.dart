class VocabMeta {
  int level;
  DateTime nextReview;
  bool isNew;
  int totalCorrectTimes;
  int totalWrongTimes;
  int correctTimesCounter;
  int wrongTimesCounter;
  DateTime? lastReview;

  VocabMeta({
    this.level = 0,
    DateTime? nextReview,
    this.isNew = true,
    this.totalCorrectTimes = 0,
    this.totalWrongTimes = 0,
    this.correctTimesCounter = 0,
    this.wrongTimesCounter = 0,
    this.lastReview,
  }) : nextReview = nextReview ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'level': level,
    'nextReview': nextReview.toIso8601String(),
    'isNew': isNew,
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
        'totalCorrect: $totalCorrectTimes, totalWrong: $totalWrongTimes, '
        'correctStreak: $correctTimesCounter, wrongStreak: $wrongTimesCounter, lastReview: $lastReview}';
  }
}
