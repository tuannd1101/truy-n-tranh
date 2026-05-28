/// Chapter model representing a manga chapter
class Chapter {
  final String id;
  final String mangaId;
  final int chapterNumber;
  final String title;
  final List<String> pageUrls;
  final DateTime updatedAt;
  final bool isPremium;

  Chapter({
    required this.id,
    required this.mangaId,
    required this.chapterNumber,
    required this.title,
    required this.pageUrls,
    required this.updatedAt,
    this.isPremium = false,
  });

  /// Create Chapter from JSON
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String,
      mangaId: json['mangaId'] as String,
      chapterNumber: json['chapterNumber'] as int,
      title: json['title'] as String,
      pageUrls: (json['pageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  /// Convert Chapter to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mangaId': mangaId,
      'chapterNumber': chapterNumber,
      'title': title,
      'pageUrls': pageUrls,
      'updatedAt': updatedAt.toIso8601String(),
      'isPremium': isPremium,
    };
  }

  /// Create a copy of Chapter with updated fields
  Chapter copyWith({
    String? id,
    String? mangaId,
    int? chapterNumber,
    String? title,
    List<String>? pageUrls,
    DateTime? updatedAt,
    bool? isPremium,
  }) {
    return Chapter(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      title: title ?? this.title,
      pageUrls: pageUrls ?? this.pageUrls,
      updatedAt: updatedAt ?? this.updatedAt,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  /// Get total number of pages
  int get totalPages => pageUrls.length;

  /// Get display title with chapter number
  String get displayTitle => 'Chapter $chapterNumber: $title';

  /// Check if chapter is free content
  bool get isFree => !isPremium;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chapter && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Chapter(id: $id, chapterNumber: $chapterNumber, title: $title, isPremium: $isPremium)';
  }
}
