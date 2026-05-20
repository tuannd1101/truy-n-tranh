import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_project/main.dart';

void main() {
  testWidgets('MangaFlow app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MangaFlowApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
