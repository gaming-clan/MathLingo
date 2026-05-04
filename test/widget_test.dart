import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathlingo/main.dart';

void main() {
  testWidgets('dashboard loads with Stitch Cosmic Logic content', (
    tester,
  ) async {
    await tester.pumpWidget(const MathLingoApp());

    expect(find.text('MathLingo'), findsOneWidget);
    expect(find.text('Sfida e Ditës'), findsWidgets);
    expect(find.text('Mirësevini!'), findsOneWidget);
    expect(find.text('Progresi i Modulit'), findsOneWidget);
    expect(find.text('Veprime të Shpejta'), findsOneWidget);
    expect(find.text('Fillo Sfidën'), findsOneWidget);
  });

  testWidgets('start challenge opens the geometry challenge flow', (
    tester,
  ) async {
    await tester.pumpWidget(const MathLingoApp());

    await tester.ensureVisible(find.byKey(const ValueKey('start-challenge')));
    await tester.tap(find.byKey(const ValueKey('start-challenge')));
    await tester.pumpAndSettle();

    expect(find.text('Sfida Gjeometrike'), findsOneWidget);
    expect(find.textContaining('Pikët:'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('correct-geometry-answer')),
      findsOneWidget,
    );
  });

  testWidgets('geometry answers complete a short challenge and show results', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: GeometryChallengeScreen(sessionLength: 1, random: Random(3)),
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('correct-geometry-answer')),
    );
    await tester.tap(find.byKey(const ValueKey('correct-geometry-answer')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Bravo!'), findsOneWidget);
    expect(find.text('+15'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('correct answers complete a short challenge and show results', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: ChallengeScreen(
          operation: Operation.addition,
          sessionLength: 1,
          random: Random(7),
        ),
      ),
    );

    await tester.ensureVisible(find.byKey(const ValueKey('correct-answer')));
    await tester.tap(find.byKey(const ValueKey('correct-answer')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Bravo!'), findsOneWidget);
    expect(find.text('+10'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
  });
}
