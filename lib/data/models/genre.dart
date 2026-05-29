class Genre {
  final String id;
  final String name;
  final String slug;

  Genre({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}

class GenreRequest {
  final String name;
  final String slug;

  GenreRequest({
    required this.name,
    required this.slug,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
    };
  }
}
