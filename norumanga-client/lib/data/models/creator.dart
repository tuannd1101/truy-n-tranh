class Creator {
  final String id;
  final String name;
  final String slug;
  final String? originalName;
  final String? biography;
  final String? avatarUrl;

  Creator({
    required this.id,
    required this.name,
    required this.slug,
    this.originalName,
    this.biography,
    this.avatarUrl,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      originalName: json['originalName'],
      biography: json['biography'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'originalName': originalName,
      'biography': biography,
      'avatarUrl': avatarUrl,
    };
  }
}

class CreatorRequest {
  final String name;
  final String slug;
  final String? originalName;
  final String? biography;
  final String? avatarUrl;

  CreatorRequest({
    required this.name,
    required this.slug,
    this.originalName,
    this.biography,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'originalName': originalName,
      'biography': biography,
      'avatarUrl': avatarUrl,
    };
  }
}
