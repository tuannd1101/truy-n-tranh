import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_project/data/models/manga.dart';

void main() {
  group('Manga Model Tests', () {
    test('should create Manga from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Manga',
        'author': 'Test Author',
        'description': 'Test Description',
        'coverUrl': 'https://example.com/cover.jpg',
        'genres': ['Action', 'Adventure'],
        'rating': 4.5,
        'status': 'Ongoing',
        'isFree': true,
        'updatedAt': '2024-01-01T00:00:00.000Z',
        'totalChapters': 10,
        'views': 1000,
      };

      // Act
      final manga = Manga.fromJson(json);

      // Assert
      expect(manga.id, '1');
      expect(manga.title, 'Test Manga');
      expect(manga.author, 'Test Author');
      expect(manga.description, 'Test Description');
      expect(manga.coverUrl, 'https://example.com/cover.jpg');
      expect(manga.genres, ['Action', 'Adventure']);
      expect(manga.rating, 4.5);
      expect(manga.status, 'Ongoing');
      expect(manga.isFree, true);
      expect(manga.totalChapters, 10);
      expect(manga.views, 1000);
    });

    test('should convert Manga to JSON', () {
      // Arrange
      final manga = Manga(
        id: '1',
        title: 'Test Manga',
        author: 'Test Author',
        description: 'Test Description',
        coverUrl: 'https://example.com/cover.jpg',
        genres: ['Action', 'Adventure'],
        rating: 4.5,
        status: 'Ongoing',
        isFree: true,
        updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        totalChapters: 10,
        views: 1000,
      );

      // Act
      final json = manga.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['title'], 'Test Manga');
      expect(json['author'], 'Test Author');
      expect(json['description'], 'Test Description');
      expect(json['coverUrl'], 'https://example.com/cover.jpg');
      expect(json['genres'], ['Action', 'Adventure']);
      expect(json['rating'], 4.5);
      expect(json['status'], 'Ongoing');
      expect(json['isFree'], true);
      expect(json['totalChapters'], 10);
      expect(json['views'], 1000);
    });

    test('should create copy with updated fields', () {
      // Arrange
      final manga = Manga(
        id: '1',
        title: 'Test Manga',
        author: 'Test Author',
        description: 'Test Description',
        coverUrl: 'https://example.com/cover.jpg',
        genres: ['Action'],
        isFree: true,
        updatedAt: DateTime.now(),
        totalChapters: 10,
      );

      // Act
      final updatedManga = manga.copyWith(
        title: 'Updated Manga',
        rating: 5.0,
      );

      // Assert
      expect(updatedManga.id, '1');
      expect(updatedManga.title, 'Updated Manga');
      expect(updatedManga.author, 'Test Author');
      expect(updatedManga.rating, 5.0);
    });

    test('should return correct isPremium value', () {
      // Arrange
      final freeManga = Manga(
        id: '1',
        title: 'Free Manga',
        author: 'Author',
        description: 'Description',
        coverUrl: 'url',
        genres: [],
        isFree: true,
        updatedAt: DateTime.now(),
        totalChapters: 10,
      );

      final premiumManga = Manga(
        id: '2',
        title: 'Premium Manga',
        author: 'Author',
        description: 'Description',
        coverUrl: 'url',
        genres: [],
        isFree: false,
        updatedAt: DateTime.now(),
        totalChapters: 10,
      );

      // Assert
      expect(freeManga.isPremium, false);
      expect(premiumManga.isPremium, true);
    });

    test('should return correct contentTag', () {
      // Arrange
      final freeManga = Manga(
        id: '1',
        title: 'Free Manga',
        author: 'Author',
        description: 'Description',
        coverUrl: 'url',
        genres: [],
        isFree: true,
        updatedAt: DateTime.now(),
        totalChapters: 10,
      );

      final premiumManga = Manga(
        id: '2',
        title: 'Premium Manga',
        author: 'Author',
        description: 'Description',
        coverUrl: 'url',
        genres: [],
        isFree: false,
        updatedAt: DateTime.now(),
        totalChapters: 10,
      );

      // Assert
      expect(freeManga.contentTag, 'Free');
      expect(premiumManga.contentTag, 'Premium');
    });

    test('should handle null values in fromJson', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Manga',
        'author': 'Test Author',
        'description': 'Test Description',
        'coverUrl': 'https://example.com/cover.jpg',
        'isFree': true,
        'updatedAt': '2024-01-01T00:00:00.000Z',
        'totalChapters': 10,
      };

      // Act
      final manga = Manga.fromJson(json);

      // Assert
      expect(manga.genres, []);
      expect(manga.rating, 0.0);
      expect(manga.status, 'Ongoing');
      expect(manga.views, 0);
    });
  });
}
