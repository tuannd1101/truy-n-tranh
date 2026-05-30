/// Chapter model representing a manga chapter
class Chapter {
  final String id;
  final String mangaId;
  final double chapterNumber;
  final List<String> pages;
  final bool isPremium;

  Chapter({
    required this.id,
    required this.mangaId,
    required this.chapterNumber,
    required this.pages,
    this.isPremium = false,
  });

  /// Create Chapter from JSON
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String,
      mangaId: json['mangaId'] as String,
      chapterNumber: (json['chapterNumber'] as num).toDouble(),
      pages: (json['pages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  /// Convert Chapter to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mangaId': mangaId,
      'chapterNumber': chapterNumber,
      'pages': pages,
      'isPremium': isPremium,
    };
  }

  /// Create a copy of Chapter with updated fields
  Chapter copyWith({
    String? id,
    String? mangaId,
    double? chapterNumber,
    List<String>? pages,
    bool? isPremium,
  }) {
    return Chapter(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      pages: pages ?? this.pages,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  /// Get total number of pages
  int get totalPages => pages.length;

  /// Get display title with chapter number
  String get displayTitle => 'Chapter $chapterNumber';

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
    return 'Chapter(id: $id, chapterNumber: $chapterNumber, isPremium: $isPremium)';
  }
}
