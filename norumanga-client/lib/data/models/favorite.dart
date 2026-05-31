import 'manga.dart';

/// A favorite (saved) manga entry for the current user.
class Favorite {
  final String id;
  final String mangaId;
  final DateTime? createdAt;
  final Manga? manga;

  Favorite({
    required this.id,
    required this.mangaId,
    this.createdAt,
    this.manga,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    final mangaJson = json['manga'];
    return Favorite(
      id: json['id'] as String? ?? '',
      mangaId: json['mangaId'] as String? ?? '',
      createdAt: _parseDate(json['createdAt']),
      manga: mangaJson is Map<String, dynamic>
          ? Manga.fromJson(mangaJson)
          : null,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }
}
