/// ReadingProgress model representing a user's reading progress for a manga chapter
class ReadingProgress {
  final String mangaId;
  final String chapterId;
  final int currentPage;
  final int totalPages;
  final DateTime lastReadAt;

  ReadingProgress({
    required this.mangaId,
    required this.chapterId,
    required this.currentPage,
    required this.totalPages,
    required this.lastReadAt,
  });

  /// Create ReadingProgress from JSON
  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      mangaId: json['mangaId'] as String,
      chapterId: json['chapterId'] as String,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      lastReadAt: DateTime.parse(json['lastReadAt'] as String),
    );
  }

  /// Convert ReadingProgress to JSON
  Map<String, dynamic> toJson() {
    return {
      'mangaId': mangaId,
      'chapterId': chapterId,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'lastReadAt': lastReadAt.toIso8601String(),
    };
  }

  /// Create a copy of ReadingProgress with updated fields
  ReadingProgress copyWith({
    String? mangaId,
    String? chapterId,
    int? currentPage,
    int? totalPages,
    DateTime? lastReadAt,
  }) {
    return ReadingProgress(
      mangaId: mangaId ?? this.mangaId,
      chapterId: chapterId ?? this.chapterId,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }

  /// Calculate progress percentage
  double get progressPercentage {
    if (totalPages <= 0) return 0.0;
    return (currentPage / totalPages) * 100;
  }

  /// Check if chapter is completed
  bool get isCompleted {
    return currentPage >= totalPages;
  }

  /// Get a unique key for this progress entry (combination of mangaId and chapterId)
  String get progressKey => '${mangaId}_$chapterId';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReadingProgress &&
        other.mangaId == mangaId &&
        other.chapterId == chapterId &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages &&
        other.lastReadAt == lastReadAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      mangaId,
      chapterId,
      currentPage,
      totalPages,
      lastReadAt,
    );
  }

  @override
  String toString() {
    return 'ReadingProgress(mangaId: $mangaId, chapterId: $chapterId, currentPage: $currentPage, totalPages: $totalPages, lastReadAt: $lastReadAt)';
  }
}
