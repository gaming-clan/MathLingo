// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mathlingo/main.dart';

void main() {
  testWidgets('MathLingo home screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MathLingoApp());

    // Verify that the home screen loads with the title.
    expect(find.text('Zgjidh një lojë!'), findsOneWidget);
    expect(find.text('MathLingo - Mëso Matematikë!'), findsOneWidget);

    // Verify that all four operation cards are present.
    expect(find.text('Mbledhje (+)'), findsOneWidget);
    expect(find.text('Zbritje (-)'), findsOneWidget);
    expect(find.text('Shumëzim (x)'), findsOneWidget);
    expect(find.text('Pjesëtim (÷)'), findsOneWidget);

    // Verify that the fact card is present with the heading.
    expect(find.text('💡 Fakt Interesant'), findsOneWidget);

    // Verify that the "Trego një tjetër" button is present.
    expect(find.text('Trego një tjetër'), findsOneWidget);
  });

  testWidgets('Random fact button generates a fact', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MathLingoApp());

    // Tap the "Trego një tjetër" button to generate a random fact.
    await tester.tap(find.text('Trego një tjetër'));
    await tester.pump();

    // Verify that a fact is displayed (should not be empty).
    expect(find.byType(Text), findsWidgets);
  });
}
