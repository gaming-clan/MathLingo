import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/features/dashboard/presentation/dashboard_screen.dart';
import 'package:math_lingo/l10n/app_localizations.dart';
import 'package:math_lingo/features/challenges/presentation/challenge_screen.dart';
import 'package:math_lingo/features/geometry/presentation/geometry_challenge_screen.dart';
import 'package:math_lingo/main.dart';
import 'package:math_lingo/models/operation.dart';
import 'package:math_lingo/shared/utils/user_progress_storage.dart';

void main() {
  late Directory hiveTestDirectory;

  setUpAll(() async {
    hiveTestDirectory = await Directory.systemTemp.createTemp(
      'mathlingo_hive_test_',
    );
    await UserProgressStorage.resetForTests(testPath: hiveTestDirectory.path);
  });

  setUp(() async {
    await UserProgressStorage.clearForTests();
  });

  Widget buildLocalizedTestApp(Widget home, {ThemeData? theme}) {
    return MaterialApp(
      locale: const Locale('sq'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme ?? ThemeData(useMaterial3: true),
      home: home,
    );
  }

  Finder buttonInside(Finder parent, Type buttonType) {
    return find.descendant(of: parent, matching: find.byType(buttonType));
  }

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

  testWidgets('dashboard tabs render body content and respond to taps', (
    tester,
  ) async {
    await tester.pumpWidget(const MathLingoApp());

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Veprime të Shpejta'), findsOneWidget);

    await tester.tap(find.text('Mësime'));
    await tester.pump();
    expect(find.text('Mjetet e Llogaritjes'), findsOneWidget);

    await tester.tap(find.text('Tabelat'));
    await tester.pump();
    expect(find.text('Tabelat Matematikore'), findsOneWidget);

    await tester.tap(find.text('Progresi'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Progresi yt po rritet çdo ditë.'), findsOneWidget);
  });

  testWidgets('start challenge opens the geometry challenge flow', (
    tester,
  ) async {
    await tester.pumpWidget(const MathLingoApp());

    final startChallengeButton = buttonInside(
      find.byKey(const ValueKey('start-challenge')),
      ElevatedButton,
    );

    await tester.ensureVisible(startChallengeButton);
    tester.widget<ElevatedButton>(startChallengeButton).onPressed!.call();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 350));

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
      buildLocalizedTestApp(
        GeometryChallengeScreen(sessionLength: 1, random: Random(3)),
      ),
    );

    final correctGeometryAnswerButton = buttonInside(
      find.byKey(const ValueKey('correct-geometry-answer')),
      OutlinedButton,
    );

    await tester.ensureVisible(correctGeometryAnswerButton);
    tester
      .widget<OutlinedButton>(correctGeometryAnswerButton)
      .onPressed!
      .call();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Bravo!'), findsOneWidget);
    expect(find.text('+15'), findsOneWidget);
    expect(find.text('100%'), findsWidgets);
  });

  testWidgets('correct answers complete a short challenge and show results', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildLocalizedTestApp(
        ChallengeScreen(
          operation: Operation.addition,
          sessionLength: 1,
          random: Random(7),
        ),
      ),
    );

    final correctAnswerButton = buttonInside(
      find.byKey(const ValueKey('correct-answer')),
      OutlinedButton,
    );

    await tester.ensureVisible(correctAnswerButton);
    tester.widget<OutlinedButton>(correctAnswerButton).onPressed!.call();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Bravo!'), findsOneWidget);
    expect(find.text('+10'), findsOneWidget);
    expect(find.text('100%'), findsWidgets);
  });
}
