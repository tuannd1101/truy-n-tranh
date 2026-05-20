import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_project/core/constants/app_colors.dart';
import 'package:prm393_project/data/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('should create User from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'role': 'premium',
        'premiumExpiryDate': '2024-12-31T23:59:59.000Z',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.role, UserRole.premium);
      expect(user.premiumExpiryDate, DateTime.parse('2024-12-31T23:59:59.000Z'));
    });

    test('should convert User to JSON', () {
      // Arrange
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        avatarUrl: 'https://example.com/avatar.jpg',
        role: UserRole.premium,
        premiumExpiryDate: DateTime.parse('2024-12-31T23:59:59.000Z'),
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['avatarUrl'], 'https://example.com/avatar.jpg');
      expect(json['role'], 'premium');
      expect(json['premiumExpiryDate'], '2024-12-31T23:59:59.000Z');
    });

    test('should create copy with updated fields', () {
      // Arrange
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: UserRole.free,
      );

      // Act
      final updatedUser = user.copyWith(
        name: 'Jane Doe',
        role: UserRole.premium,
      );

      // Assert
      expect(updatedUser.id, '1');
      expect(updatedUser.name, 'Jane Doe');
      expect(updatedUser.email, 'john@example.com');
      expect(updatedUser.role, UserRole.premium);
    });

    test('should return correct isPremium value', () {
      // Arrange
      final premiumUser = User(
        id: '1',
        name: 'Premium User',
        email: 'premium@example.com',
        role: UserRole.premium,
      );

      final freeUser = User(
        id: '2',
        name: 'Free User',
        email: 'free@example.com',
        role: UserRole.free,
      );

      final guestUser = User(
        id: '3',
        name: 'Guest User',
        email: 'guest@example.com',
        role: UserRole.guest,
      );

      // Assert
      expect(premiumUser.isPremium, true);
      expect(freeUser.isPremium, false);
      expect(guestUser.isPremium, false);
    });

    test('should return correct isFree value', () {
      // Arrange
      final premiumUser = User(
        id: '1',
        name: 'Premium User',
        email: 'premium@example.com',
        role: UserRole.premium,
      );

      final freeUser = User(
        id: '2',
        name: 'Free User',
        email: 'free@example.com',
        role: UserRole.free,
      );

      final guestUser = User(
        id: '3',
        name: 'Guest User',
        email: 'guest@example.com',
        role: UserRole.guest,
      );

      // Assert
      expect(premiumUser.isFree, false);
      expect(freeUser.isFree, true);
      expect(guestUser.isFree, false);
    });

    test('should return correct isGuest value', () {
      // Arrange
      final premiumUser = User(
        id: '1',
        name: 'Premium User',
        email: 'premium@example.com',
        role: UserRole.premium,
      );

      final freeUser = User(
        id: '2',
        name: 'Free User',
        email: 'free@example.com',
        role: UserRole.free,
      );

      final guestUser = User(
        id: '3',
        name: 'Guest User',
        email: 'guest@example.com',
        role: UserRole.guest,
      );

      // Assert
      expect(premiumUser.isGuest, false);
      expect(freeUser.isGuest, false);
      expect(guestUser.isGuest, true);
    });

    test('should return correct roleBadgeText', () {
      // Arrange
      final premiumUser = User(
        id: '1',
        name: 'Premium User',
        email: 'premium@example.com',
        role: UserRole.premium,
      );

      final freeUser = User(
        id: '2',
        name: 'Free User',
        email: 'free@example.com',
        role: UserRole.free,
      );

      final guestUser = User(
        id: '3',
        name: 'Guest User',
        email: 'guest@example.com',
        role: UserRole.guest,
      );

      // Assert
      expect(premiumUser.roleBadgeText, 'Premium User');
      expect(freeUser.roleBadgeText, 'Free User');
      expect(guestUser.roleBadgeText, 'Guest');
    });

    test('should return correct roleBadgeColor', () {
      // Arrange
      final premiumUser = User(
        id: '1',
        name: 'Premium User',
        email: 'premium@example.com',
        role: UserRole.premium,
      );

      final freeUser = User(
        id: '2',
        name: 'Free User',
        email: 'free@example.com',
        role: UserRole.free,
      );

      final guestUser = User(
        id: '3',
        name: 'Guest User',
        email: 'guest@example.com',
        role: UserRole.guest,
      );

      // Assert
      expect(premiumUser.roleBadgeColor, AppColors.primary);
      expect(freeUser.roleBadgeColor, AppColors.grey);
      expect(guestUser.roleBadgeColor, AppColors.grey);
    });

    test('should handle null avatarUrl in fromJson', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'free',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.avatarUrl, null);
      expect(user.premiumExpiryDate, null);
    });

    test('should handle invalid role in fromJson', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'invalid_role',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.role, UserRole.guest); // Should default to guest
    });

    test('should correctly compare two User instances', () {
      // Arrange
      final user1 = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: UserRole.premium,
      );

      final user2 = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: UserRole.premium,
      );

      final user3 = User(
        id: '2',
        name: 'Jane Doe',
        email: 'jane@example.com',
        role: UserRole.free,
      );

      // Assert
      expect(user1 == user2, true);
      expect(user1 == user3, false);
    });

    test('should have consistent hashCode for equal objects', () {
      // Arrange
      final user1 = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: UserRole.premium,
      );

      final user2 = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: UserRole.premium,
      );

      // Assert
      expect(user1.hashCode, user2.hashCode);
    });

    test('should return correct toString', () {
      // Arrange
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: UserRole.premium,
      );

      // Act
      final result = user.toString();

      // Assert
      expect(result, contains('User'));
      expect(result, contains('id: 1'));
      expect(result, contains('name: John Doe'));
      expect(result, contains('email: john@example.com'));
      expect(result, contains('role: UserRole.premium'));
    });
  });
}
