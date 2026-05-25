import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:prm393_project/core/routes/app_router.dart';
import 'package:prm393_project/core/routes/app_routes.dart';
import 'package:prm393_project/providers/auth_provider.dart';
import 'package:prm393_project/data/models/user.dart';

void main() {
  group('AppRouter', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider();
    });

    Widget createTestApp({
      required String initialRoute,
      Map<String, dynamic>? arguments,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ],
        child: MaterialApp(
          navigatorKey: AppRouter.navigatorKey,
          initialRoute: initialRoute,
          onGenerateRoute: AppRouter.generateRoute,
        ),
      );
    }

    group('Route Generation', () {
      testWidgets('generates home route', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.home));
        await tester.pumpAndSettle();

        expect(find.text('Main Screen'), findsOneWidget);
      });

      testWidgets('generates login route', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.login));
        await tester.pumpAndSettle();

        expect(find.text('Login Screen'), findsOneWidget);
      });

      testWidgets('generates register route', (WidgetTester tester) async {
        await tester
            .pumpWidget(createTestApp(initialRoute: AppRoutes.register));
        await tester.pumpAndSettle();

        expect(find.text('Register Screen'), findsOneWidget);
      });

      testWidgets('generates search route', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(initialRoute: AppRoutes.search));
        await tester.pumpAndSettle();

        expect(find.text('Search Screen'), findsOneWidget);
      });

      testWidgets('generates profile route', (WidgetTester tester) async {
        await tester
            .pumpWidget(createTestApp(initialRoute: AppRoutes.profile));
        await tester.pumpAndSettle();

        expect(find.text('Profile Screen'), findsOneWidget);
      });
    });

    group('Route Arguments', () {
      testWidgets('passes manga ID to detail screen',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: MaterialApp(
              navigatorKey: AppRouter.navigatorKey,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.mangaDetail,
                        arguments: {'mangaId': 'manga123'},
                      );
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.textContaining('manga123'), findsOneWidget);
      });

      testWidgets('passes reading parameters', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: MaterialApp(
              navigatorKey: AppRouter.navigatorKey,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.reading,
                        arguments: {
                          'mangaId': 'manga123',
                          'chapterId': 'chapter456',
                          'isPremium': false,
                        },
                      );
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.textContaining('manga123'), findsOneWidget);
        expect(find.textContaining('chapter456'), findsOneWidget);
      });

      testWidgets('shows error when manga ID is missing',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: MaterialApp(
              navigatorKey: AppRouter.navigatorKey,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.mangaDetail,
                        arguments: {},
                      );
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.text('Navigation Error'), findsOneWidget);
        expect(find.textContaining('Manga ID is required'), findsOneWidget);
      });
    });

    group('Authentication Guards', () {
      testWidgets('redirects to login when accessing protected route',
          (WidgetTester tester) async {
        await tester
            .pumpWidget(createTestApp(initialRoute: AppRoutes.library));
        await tester.pumpAndSettle();

        // Should redirect to login
        expect(find.text('Login Screen'), findsOneWidget);
      });

      testWidgets('allows access to protected route when authenticated',
          (WidgetTester tester) async {
        // Authenticate user
        authProvider.login('test@example.com', 'password');
        await Future.delayed(const Duration(seconds: 2));

        await tester
            .pumpWidget(createTestApp(initialRoute: AppRoutes.library));
        await tester.pumpAndSettle();

        // Should show library screen
        expect(find.text('Library Screen'), findsOneWidget);
      });

      testWidgets('redirects to login for favorites when not authenticated',
          (WidgetTester tester) async {
        await tester
            .pumpWidget(createTestApp(initialRoute: AppRoutes.favorites));
        await tester.pumpAndSettle();

        expect(find.text('Login Screen'), findsOneWidget);
      });

      testWidgets('redirects to login for history when not authenticated',
          (WidgetTester tester) async {
        await tester
            .pumpWidget(createTestApp(initialRoute: AppRoutes.history));
        await tester.pumpAndSettle();

        expect(find.text('Login Screen'), findsOneWidget);
      });

      testWidgets('redirects to login for settings when not authenticated',
          (WidgetTester tester) async {
        await tester
            .pumpWidget(createTestApp(initialRoute: AppRoutes.settings));
        await tester.pumpAndSettle();

        expect(find.text('Login Screen'), findsOneWidget);
      });
    });

    group('Premium Content Guards', () {
      testWidgets('blocks premium content for free users',
          (WidgetTester tester) async {
        // Authenticate as free user
        authProvider.login('test@example.com', 'password');
        await Future.delayed(const Duration(seconds: 2));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: MaterialApp(
              navigatorKey: AppRouter.navigatorKey,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.reading,
                        arguments: {
                          'mangaId': 'manga123',
                          'chapterId': 'chapter456',
                          'isPremium': true,
                        },
                      );
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        // Should show premium content blocked screen
        expect(find.text('Premium Content'), findsOneWidget);
        expect(find.text('Upgrade to Premium'), findsOneWidget);
      });

      testWidgets('allows premium content for premium users',
          (WidgetTester tester) async {
        // Authenticate and upgrade to premium
        authProvider.login('test@example.com', 'password');
        await Future.delayed(const Duration(seconds: 2));
        authProvider.upgradeToPremium();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: MaterialApp(
              navigatorKey: AppRouter.navigatorKey,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.reading,
                        arguments: {
                          'mangaId': 'manga123',
                          'chapterId': 'chapter456',
                          'isPremium': true,
                        },
                      );
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        // Should show reading screen
        expect(find.textContaining('Reading Screen'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('shows error for unknown route', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(initialRoute: '/unknown'));
        await tester.pumpAndSettle();

        expect(find.text('Navigation Error'), findsOneWidget);
        expect(find.textContaining('Route not found'), findsOneWidget);
      });

      testWidgets('provides go to home button on error',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(initialRoute: '/unknown'));
        await tester.pumpAndSettle();

        expect(find.text('Go to Home'), findsOneWidget);
      });
    });

    group('Navigation Helper Methods', () {
      testWidgets('navigateTo pushes new route', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: MaterialApp(
              navigatorKey: AppRouter.navigatorKey,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AppRouter.navigateTo(AppRoutes.search);
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.text('Search Screen'), findsOneWidget);
      });

      testWidgets('goBack pops route', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: MaterialApp(
              navigatorKey: AppRouter.navigatorKey,
              home: Builder(
                builder: (context) => Scaffold(
                  body: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          AppRouter.navigateTo(AppRoutes.search);
                        },
                        child: const Text('Navigate'),
                      ),
                    ],
                  ),
                ),
              ),
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.text('Search Screen'), findsOneWidget);

        AppRouter.goBack();
        await tester.pumpAndSettle();

        expect(find.text('Navigate'), findsOneWidget);
      });

      testWidgets('canGoBack returns correct value',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: MaterialApp(
              navigatorKey: AppRouter.navigatorKey,
              home: const Scaffold(body: Text('Home')),
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Initially can't go back
        expect(AppRouter.canGoBack(), false);

        // Navigate to another screen
        AppRouter.navigateTo(AppRoutes.search);
        await tester.pumpAndSettle();

        // Now can go back
        expect(AppRouter.canGoBack(), true);
      });
    });
  });
}
