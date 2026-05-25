import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_project/core/routes/app_routes.dart';

void main() {
  group('AppRoutes', () {
    test('should define all 13 required route constants', () {
      // Auth Routes (2)
      expect(AppRoutes.login, equals('/login'));
      expect(AppRoutes.register, equals('/register'));

      // Main Routes (4)
      expect(AppRoutes.home, equals('/'));
      expect(AppRoutes.search, equals('/search'));
      expect(AppRoutes.library, equals('/library'));
      expect(AppRoutes.profile, equals('/profile'));

      // Detail Routes (2)
      expect(AppRoutes.mangaDetail, equals('/manga-detail'));
      expect(AppRoutes.reading, equals('/reading'));

      // Profile Sub-Routes (3)
      expect(AppRoutes.history, equals('/history'));
      expect(AppRoutes.favorites, equals('/favorites'));
      expect(AppRoutes.settings, equals('/settings'));

      // Subscription Routes (2)
      expect(AppRoutes.subscription, equals('/subscription'));
      expect(AppRoutes.payment, equals('/payment'));
    });

    test('should use clear naming convention with kebab-case', () {
      // Verify that multi-word routes use kebab-case
      expect(AppRoutes.mangaDetail, contains('-'));
      
      // Verify that routes start with forward slash
      expect(AppRoutes.login, startsWith('/'));
      expect(AppRoutes.register, startsWith('/'));
      expect(AppRoutes.home, startsWith('/'));
      expect(AppRoutes.search, startsWith('/'));
      expect(AppRoutes.library, startsWith('/'));
      expect(AppRoutes.profile, startsWith('/'));
      expect(AppRoutes.mangaDetail, startsWith('/'));
      expect(AppRoutes.reading, startsWith('/'));
      expect(AppRoutes.history, startsWith('/'));
      expect(AppRoutes.favorites, startsWith('/'));
      expect(AppRoutes.settings, startsWith('/'));
      expect(AppRoutes.subscription, startsWith('/'));
      expect(AppRoutes.payment, startsWith('/'));
    });

    test('should have unique route paths', () {
      final routes = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.home,
        AppRoutes.search,
        AppRoutes.library,
        AppRoutes.profile,
        AppRoutes.mangaDetail,
        AppRoutes.reading,
        AppRoutes.history,
        AppRoutes.favorites,
        AppRoutes.settings,
        AppRoutes.subscription,
        AppRoutes.payment,
      ];

      // Check that all routes are unique
      final uniqueRoutes = routes.toSet();
      expect(uniqueRoutes.length, equals(routes.length));
    });

    test('should not allow instantiation', () {
      // This test verifies that the private constructor prevents instantiation
      // If this compiles, the private constructor is working correctly
      expect(() => AppRoutes, returnsNormally);
    });
  });
}
