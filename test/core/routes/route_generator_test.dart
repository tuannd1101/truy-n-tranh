import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:prm393_project/core/routes/app_routes.dart';
import 'package:prm393_project/core/routes/route_generator.dart';
import 'package:prm393_project/providers/auth_provider.dart';

void main() {
  group('RouteGenerator', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider();
    });

    Widget createTestApp({required String initialRoute, Object? arguments}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ],
        child: MaterialApp(
          navigatorKey: RouteGenerator.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: initialRoute,
        ),
      );
    }

    testWidgets('should generate route for login screen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.login));
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('should generate route for register screen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.register));
      await tester.pumpAndSettle();

      expect(find.text('Register Screen'), findsOneWidget);
    });

    testWidgets('should generate route for home screen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.home));
      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('should generate route for search screen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.search));
      await tester.pumpAndSettle();

      expect(find.text('Search Screen'), findsOneWidget);
    });

    testWidgets('should extract manga ID from route parameters', (tester) async {
      await tester.pumpWidget(
        createTestApp(initialRoute: '${AppRoutes.mangaDetail}?id=123'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manga Detail - ID: 123'), findsOneWidget);
    });

    testWidgets('should extract manga ID and chapter ID from route parameters',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          initialRoute: '${AppRoutes.reading}?mangaId=123&chapterId=456',
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Reading - Manga: 123, Chapter: 456'),
        findsOneWidget,
      );
    });

    testWidgets('should show error for manga detail without ID', (tester) async {
      await tester.pumpWidget(
        createTestApp(initialRoute: AppRoutes.mangaDetail),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manga ID is required'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should show error for reading without parameters',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(initialRoute: AppRoutes.reading),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manga ID and Chapter ID are required'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should guard protected routes when not authenticated',
        (tester) async {
      // Ensure user is not authenticated
      expect(authProvider.isAuthenticated, false);

      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.library));
      await tester.pumpAndSettle();

      // Should redirect to login
      expect(find.text('Login Required'), findsOneWidget);
    });

    testWidgets('should allow access to protected routes when authenticated',
        (tester) async {
      // Authenticate user
      await authProvider.login('test@example.com', 'password');
      expect(authProvider.isAuthenticated, true);

      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.library));
      await tester.pumpAndSettle();

      // Should show library screen
      expect(find.text('Library Screen'), findsOneWidget);
    });

    testWidgets('should guard favorites route when not authenticated',
        (tester) async {
      expect(authProvider.isAuthenticated, false);

      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.favorites));
      await tester.pumpAndSettle();

      expect(find.text('Login Required'), findsOneWidget);
    });

    testWidgets('should guard history route when not authenticated',
        (tester) async {
      expect(authProvider.isAuthenticated, false);

      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.history));
      await tester.pumpAndSettle();

      expect(find.text('Login Required'), findsOneWidget);
    });

    testWidgets('should guard settings route when not authenticated',
        (tester) async {
      expect(authProvider.isAuthenticated, false);

      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.settings));
      await tester.pumpAndSettle();

      expect(find.text('Login Required'), findsOneWidget);
    });

    testWidgets('should guard subscription route when not authenticated',
        (tester) async {
      expect(authProvider.isAuthenticated, false);

      await tester.pumpWidget(
        createTestApp(initialRoute: AppRoutes.subscription),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login Required'), findsOneWidget);
    });

    testWidgets('should guard payment route when not authenticated',
        (tester) async {
      expect(authProvider.isAuthenticated, false);

      await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.payment));
      await tester.pumpAndSettle();

      expect(find.text('Login Required'), findsOneWidget);
    });

    testWidgets('should show error for unknown route', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/unknown'));
      await tester.pumpAndSettle();

      expect(find.text('Route not found: /unknown'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    // Note: _requiresAuth is a private method, so we test it indirectly
    // through the route generation behavior tested in the widget tests above
  });

  group('RouteGenerator helper methods', () {
    testWidgets('navigateToMangaDetail should navigate with correct parameters',
        (tester) async {
      final authProvider = AuthProvider();
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ],
          child: MaterialApp(
            navigatorKey: RouteGenerator.navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      RouteGenerator.navigateToMangaDetail(context, '123');
                    },
                    child: const Text('Navigate'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.text('Manga Detail - ID: 123'), findsOneWidget);
    });

    testWidgets('navigateToReading should navigate with correct parameters',
        (tester) async {
      final authProvider = AuthProvider();
      await authProvider.login('test@example.com', 'password');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ],
          child: MaterialApp(
            navigatorKey: RouteGenerator.navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      RouteGenerator.navigateToReading(context, '123', '456');
                    },
                    child: const Text('Navigate'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(
        find.text('Reading - Manga: 123, Chapter: 456'),
        findsOneWidget,
      );
    });

    testWidgets('navigateToPayment should navigate with correct parameters',
        (tester) async {
      final authProvider = AuthProvider();
      await authProvider.login('test@example.com', 'password');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ],
          child: MaterialApp(
            navigatorKey: RouteGenerator.navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      RouteGenerator.navigateToPayment(context, 'premium-monthly');
                    },
                    child: const Text('Navigate'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.text('Payment - Plan: premium-monthly'), findsOneWidget);
    });
  });
}
