class Tag {
  final String id;
  final String name;
  final String slug;
  final String group;

  Tag({
    required this.id,
    required this.name,
    required this.slug,
    required this.group,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      group: json['group'] ?? 'THEME',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'group': group,
    };
  }
}

class TagRequest {
  final String name;
  final String slug;
  final String group;

  TagRequest({
    required this.name,
    required this.slug,
    required this.group,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'group': group,
    };
  }
}
