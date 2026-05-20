import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_project/data/models/reading_progress.dart';

void main() {
  group('ReadingProgress Model Tests', () {
    test('should create ReadingProgress from JSON', () {
      // Arrange
      final json = {
        'mangaId': 'manga1',
        'chapterId': 'chapter1',
        'currentPage': 5,
        'totalPages': 20,
        'lastReadAt': '2024-01-15T10:30:00.000Z',
      };

      // Act
      final progress = ReadingProgress.fromJson(json);

      // Assert
      expect(progress.mangaId, 'manga1');
      expect(progress.chapterId, 'chapter1');
      expect(progress.currentPage, 5);
      expect(progress.totalPages, 20);
      expect(progress.lastReadAt, DateTime.parse('2024-01-15T10:30:00.000Z'));
    });

    test('should convert ReadingProgress to JSON', () {
      // Arrange
      final progress = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
      );

      // Act
      final json = progress.toJson();

      // Assert
      expect(json['mangaId'], 'manga1');
      expect(json['chapterId'], 'chapter1');
      expect(json['currentPage'], 5);
      expect(json['totalPages'], 20);
      expect(json['lastReadAt'], '2024-01-15T10:30:00.000Z');
    });

    test('should create copy with updated fields', () {
      // Arrange
      final progress = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: DateTime.now(),
      );

      // Act
      final updatedProgress = progress.copyWith(
        currentPage: 10,
        totalPages: 25,
      );

      // Assert
      expect(updatedProgress.mangaId, 'manga1');
      expect(updatedProgress.chapterId, 'chapter1');
      expect(updatedProgress.currentPage, 10);
      expect(updatedProgress.totalPages, 25);
    });

    test('should calculate correct progressPercentage', () {
      // Arrange
      final progress1 = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: DateTime.now(),
      );

      final progress2 = ReadingProgress(
        mangaId: 'manga2',
        chapterId: 'chapter2',
        currentPage: 10,
        totalPages: 10,
        lastReadAt: DateTime.now(),
      );

      final progress3 = ReadingProgress(
        mangaId: 'manga3',
        chapterId: 'chapter3',
        currentPage: 0,
        totalPages: 10,
        lastReadAt: DateTime.now(),
      );

      // Assert
      expect(progress1.progressPercentage, 25.0);
      expect(progress2.progressPercentage, 100.0);
      expect(progress3.progressPercentage, 0.0);
    });

    test('should handle zero totalPages in progressPercentage', () {
      // Arrange
      final progress = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 0,
        lastReadAt: DateTime.now(),
      );

      // Assert
      expect(progress.progressPercentage, 0.0);
    });

    test('should handle negative totalPages in progressPercentage', () {
      // Arrange
      final progress = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: -10,
        lastReadAt: DateTime.now(),
      );

      // Assert
      expect(progress.progressPercentage, 0.0);
    });

    test('should return correct isCompleted value', () {
      // Arrange
      final completedProgress = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 20,
        totalPages: 20,
        lastReadAt: DateTime.now(),
      );

      final incompleteProgress = ReadingProgress(
        mangaId: 'manga2',
        chapterId: 'chapter2',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: DateTime.now(),
      );

      final overCompletedProgress = ReadingProgress(
        mangaId: 'manga3',
        chapterId: 'chapter3',
        currentPage: 25,
        totalPages: 20,
        lastReadAt: DateTime.now(),
      );

      // Assert
      expect(completedProgress.isCompleted, true);
      expect(incompleteProgress.isCompleted, false);
      expect(overCompletedProgress.isCompleted, true);
    });

    test('should return correct progressKey', () {
      // Arrange
      final progress = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: DateTime.now(),
      );

      // Assert
      expect(progress.progressKey, 'manga1_chapter1');
    });

    test('should correctly compare two ReadingProgress instances', () {
      // Arrange
      final lastReadAt = DateTime.parse('2024-01-15T10:30:00.000Z');
      
      final progress1 = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: lastReadAt,
      );

      final progress2 = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: lastReadAt,
      );

      final progress3 = ReadingProgress(
        mangaId: 'manga2',
        chapterId: 'chapter2',
        currentPage: 10,
        totalPages: 30,
        lastReadAt: DateTime.now(),
      );

      // Assert
      expect(progress1 == progress2, true);
      expect(progress1 == progress3, false);
    });

    test('should have consistent hashCode for equal objects', () {
      // Arrange
      final lastReadAt = DateTime.parse('2024-01-15T10:30:00.000Z');
      
      final progress1 = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: lastReadAt,
      );

      final progress2 = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: lastReadAt,
      );

      // Assert
      expect(progress1.hashCode, progress2.hashCode);
    });

    test('should return correct toString', () {
      // Arrange
      final progress = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 5,
        totalPages: 20,
        lastReadAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
      );

      // Act
      final result = progress.toString();

      // Assert
      expect(result, contains('ReadingProgress'));
      expect(result, contains('mangaId: manga1'));
      expect(result, contains('chapterId: chapter1'));
      expect(result, contains('currentPage: 5'));
      expect(result, contains('totalPages: 20'));
    });

    test('should handle edge case where currentPage equals totalPages', () {
      // Arrange
      final progress = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 20,
        totalPages: 20,
        lastReadAt: DateTime.now(),
      );

      // Assert
      expect(progress.progressPercentage, 100.0);
      expect(progress.isCompleted, true);
    });

    test('should handle edge case where currentPage is 0', () {
      // Arrange
      final progress = ReadingProgress(
        mangaId: 'manga1',
        chapterId: 'chapter1',
        currentPage: 0,
        totalPages: 20,
        lastReadAt: DateTime.now(),
      );

      // Assert
      expect(progress.progressPercentage, 0.0);
      expect(progress.isCompleted, false);
    });
  });
}
