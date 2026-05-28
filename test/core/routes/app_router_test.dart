import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_project/core/routes/app_router.dart';

void main() {
  group('AppRouter Route Generation', () {
    Widget createTestApp({
      required String initialRoute,
      Map<String, dynamic>? arguments,
    }) {
      return MaterialApp(
        initialRoute: initialRoute,
        onGenerateRoute: AppRouter.generateRoute,
      );
    }

    testWidgets('generates login route', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: AppRouter.login));
      await tester.pumpAndSettle();
      expect(find.text('ENTER THE FLOW'), findsOneWidget); // Assuming Login screen has this text
    });

    testWidgets('generates home route', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: AppRouter.home));
      await tester.pumpAndSettle();
      expect(find.text('MangaFlow'), findsWidgets); // Assuming Home screen has this
    });

    testWidgets('shows error for unknown route', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/unknown-route'));
      await tester.pumpAndSettle();

      expect(find.text('Navigation Error'), findsOneWidget);
      expect(find.textContaining('Route not found'), findsOneWidget);
    });
  });
}
