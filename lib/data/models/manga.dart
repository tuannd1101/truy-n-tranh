/// Manga model representing a manga entity
class Manga {
  final String id;
  final String title;
  final String slug;
  final String description;
  final String coverUrl;
  final List<String> creatorIds;
  final List<String> tags;
  final String status;
  final bool isFree;
  final DateTime updatedAt;

  Manga({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.coverUrl,
    required this.creatorIds,
    required this.tags,
    this.status = 'Ongoing',
    required this.isFree,
    required this.updatedAt,
  });

  /// Create Manga from JSON
  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      coverUrl: json['coverUrl'] as String? ?? '',
      creatorIds: (json['creatorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      status: json['status'] as String? ?? 'Ongoing',
      isFree: !(json['isPremium'] as bool? ?? false),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert Manga to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'coverUrl': coverUrl,
      'creatorIds': creatorIds,
      'tags': tags,
      'status': status,
      'isPremium': !isFree,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of Manga with updated fields
  Manga copyWith({
    String? id,
    String? title,
    String? slug,
    String? description,
    String? coverUrl,
    List<String>? creatorIds,
    List<String>? tags,
    String? status,
    bool? isFree,
    DateTime? updatedAt,
  }) {
    return Manga(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      creatorIds: creatorIds ?? this.creatorIds,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      isFree: isFree ?? this.isFree,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if manga is premium content
  bool get isPremium => !isFree;

  /// Get content tag text
  String get contentTag => isFree ? 'Free' : 'Premium';

  /// Getter for backward compatibility
  String get author => creatorIds.isNotEmpty ? creatorIds.first : 'Unknown';

  /// Getter for backward compatibility with Genre
  List<String> get genres => tags;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Manga && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Manga(id: $id, title: $title, isFree: $isFree)';
  }
}
