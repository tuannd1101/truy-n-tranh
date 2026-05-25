import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_project/data/models/chapter.dart';

void main() {
  group('Chapter Model Tests', () {
    test('should create Chapter from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'mangaId': 'manga1',
        'chapterNumber': 1,
        'title': 'The Beginning',
        'pageUrls': [
          'https://example.com/page1.jpg',
          'https://example.com/page2.jpg',
          'https://example.com/page3.jpg',
        ],
        'updatedAt': '2024-01-01T00:00:00.000Z',
        'isPremium': false,
      };

      // Act
      final chapter = Chapter.fromJson(json);

      // Assert
      expect(chapter.id, '1');
      expect(chapter.mangaId, 'manga1');
      expect(chapter.chapterNumber, 1);
      expect(chapter.title, 'The Beginning');
      expect(chapter.pageUrls.length, 3);
      expect(chapter.isPremium, false);
    });

    test('should convert Chapter to JSON', () {
      // Arrange
      final chapter = Chapter(
        id: '1',
        mangaId: 'manga1',
        chapterNumber: 1,
        title: 'The Beginning',
        pageUrls: [
          'https://example.com/page1.jpg',
          'https://example.com/page2.jpg',
        ],
        updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        isPremium: false,
      );

      // Act
      final json = chapter.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['mangaId'], 'manga1');
      expect(json['chapterNumber'], 1);
      expect(json['title'], 'The Beginning');
      expect(json['pageUrls'], [
        'https://example.com/page1.jpg',
        'https://example.com/page2.jpg',
      ]);
      expect(json['isPremium'], false);
    });

    test('should create copy with updated fields', () {
      // Arrange
      final chapter = Chapter(
        id: '1',
        mangaId: 'manga1',
        chapterNumber: 1,
        title: 'The Beginning',
        pageUrls: ['url1', 'url2'],
        updatedAt: DateTime.now(),
        isPremium: false,
      );

      // Act
      final updatedChapter = chapter.copyWith(
        title: 'Updated Title',
        isPremium: true,
      );

      // Assert
      expect(updatedChapter.id, '1');
      expect(updatedChapter.title, 'Updated Title');
      expect(updatedChapter.isPremium, true);
      expect(updatedChapter.chapterNumber, 1);
    });

    test('should return correct totalPages', () {
      // Arrange
      final chapter = Chapter(
        id: '1',
        mangaId: 'manga1',
        chapterNumber: 1,
        title: 'Test',
        pageUrls: ['url1', 'url2', 'url3', 'url4', 'url5'],
        updatedAt: DateTime.now(),
      );

      // Assert
      expect(chapter.totalPages, 5);
    });

    test('should return correct displayTitle', () {
      // Arrange
      final chapter = Chapter(
        id: '1',
        mangaId: 'manga1',
        chapterNumber: 5,
        title: 'The Battle Begins',
        pageUrls: ['url1'],
        updatedAt: DateTime.now(),
      );

      // Assert
      expect(chapter.displayTitle, 'Chapter 5: The Battle Begins');
    });

    test('should return correct isFree value', () {
      // Arrange
      final freeChapter = Chapter(
        id: '1',
        mangaId: 'manga1',
        chapterNumber: 1,
        title: 'Free Chapter',
        pageUrls: ['url1'],
        updatedAt: DateTime.now(),
        isPremium: false,
      );

      final premiumChapter = Chapter(
        id: '2',
        mangaId: 'manga1',
        chapterNumber: 2,
        title: 'Premium Chapter',
        pageUrls: ['url1'],
        updatedAt: DateTime.now(),
        isPremium: true,
      );

      // Assert
      expect(freeChapter.isFree, true);
      expect(premiumChapter.isFree, false);
    });

    test('should handle null values in fromJson', () {
      // Arrange
      final json = {
        'id': '1',
        'mangaId': 'manga1',
        'chapterNumber': 1,
        'title': 'Test Chapter',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      };

      // Act
      final chapter = Chapter.fromJson(json);

      // Assert
      expect(chapter.pageUrls, []);
      expect(chapter.isPremium, false);
    });

    test('should handle empty pageUrls list', () {
      // Arrange
      final chapter = Chapter(
        id: '1',
        mangaId: 'manga1',
        chapterNumber: 1,
        title: 'Empty Chapter',
        pageUrls: [],
        updatedAt: DateTime.now(),
      );

      // Assert
      expect(chapter.totalPages, 0);
      expect(chapter.pageUrls, []);
    });
  });
}
