/// Manga model representing a manga entity
class Manga {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final List<String> genres;
  final double rating;
  final String status;
  final bool isFree;
  final DateTime updatedAt;
  final int totalChapters;
  final int views;

  Manga({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.genres,
    this.rating = 0.0,
    this.status = 'Ongoing',
    required this.isFree,
    required this.updatedAt,
    required this.totalChapters,
    this.views = 0,
  });

  /// Create Manga from JSON
  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'Ongoing',
      isFree: json['isFree'] as bool? ?? false,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      totalChapters: json['totalChapters'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
    );
  }

  /// Convert Manga to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'genres': genres,
      'rating': rating,
      'status': status,
      'isFree': isFree,
      'updatedAt': updatedAt.toIso8601String(),
      'totalChapters': totalChapters,
      'views': views,
    };
  }

  /// Create a copy of Manga with updated fields
  Manga copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    List<String>? genres,
    double? rating,
    String? status,
    bool? isFree,
    DateTime? updatedAt,
    int? totalChapters,
    int? views,
  }) {
    return Manga(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      genres: genres ?? this.genres,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      isFree: isFree ?? this.isFree,
      updatedAt: updatedAt ?? this.updatedAt,
      totalChapters: totalChapters ?? this.totalChapters,
      views: views ?? this.views,
    );
  }

  /// Check if manga is premium content
  bool get isPremium => !isFree;

  /// Get content tag text
  String get contentTag => isFree ? 'Free' : 'Premium';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Manga && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Manga(id: $id, title: $title, author: $author, isFree: $isFree)';
  }
}
