import 'manga.dart';

/// A reading history entry: the most recently read chapter of a manga.
class ReadingHistoryEntry {
  final String id;
  final String mangaId;
  final double? chapterNumber;
  final DateTime? lastReadAt;
  final Manga? manga;

  ReadingHistoryEntry({
    required this.id,
    required this.mangaId,
    this.chapterNumber,
    this.lastReadAt,
    this.manga,
  });

  factory ReadingHistoryEntry.fromJson(Map<String, dynamic> json) {
    final mangaJson = json['manga'];
    return ReadingHistoryEntry(
      id: json['id'] as String? ?? '',
      mangaId: json['mangaId'] as String? ?? '',
      chapterNumber: (json['chapterNumber'] as num?)?.toDouble(),
      lastReadAt: _parseDate(json['lastReadAt']),
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
