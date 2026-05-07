// D1: Widget tests për GeometryChallengeScreen landscape layout + hint chip
// Teston se FormulaReferencePanel shfaqet në landscape dhe HintChip funksionon.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/features/geometry/presentation/geometry_challenge_screen.dart';
import 'package:math_lingo/features/geometry/widgets/formula_reference_panel.dart';
import 'package:math_lingo/l10n/app_localizations.dart';
import 'package:math_lingo/shared/widgets/geometry_hint_chip.dart';
import 'package:math_lingo/shared/utils/user_progress_storage.dart';

import 'dart:io';

Widget buildTestApp(
  Widget home, {
  required double width,
  required double height,
}) {
  return ProviderScope(
    child: MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: MaterialApp(
        locale: const Locale('sq'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(useMaterial3: true),
        home: home,
      ),
    ),
  );
}


void main() {
  late Directory hiveTestDir;

  setUpAll(() async {
    hiveTestDir = await Directory.systemTemp.createTemp('geometry_landscape_test_');
    await UserProgressStorage.resetForTests(testPath: hiveTestDir.path);
  });

  tearDownAll(() async {
    // Mbyll Hive para se të fshijmë direktorinë (evito Windows file lock)
    try {
      await hiveTestDir.delete(recursive: true);
    } catch (_) {
      // Ignore lock errors on Windows
    }
  });

  group('GeometryChallengeScreen — portrait (800×1200)', () {
    testWidgets('nuk shfaq FormulaReferencePanel', (tester) async {
      tester.view.physicalSize = const Size(800 * 2, 1200 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          GeometryChallengeScreen(random: Random(42)),
          width: 800,
          height: 1200,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FormulaReferencePanel), findsNothing);
    });

    testWidgets('shfaq GeometryHintChip (i fshehtë fillimisht)', (tester) async {
      tester.view.physicalSize = const Size(800 * 2, 1200 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          GeometryChallengeScreen(random: Random(42)),
          width: 800,
          height: 1200,
        ),
      );
      await tester.pumpAndSettle();

      // Chip ekziston por është invisible (opacity 0) fillimisht
      final chip = tester.widget<GeometryHintChip>(
        find.byType(GeometryHintChip),
      );
      expect(chip.visible, isFalse);
    });
  });

  group('GeometryChallengeScreen — landscape (1200×800)', () {
    testWidgets('shfaq FormulaReferencePanel', (tester) async {
      tester.view.physicalSize = const Size(1200 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          GeometryChallengeScreen(random: Random(42)),
          width: 1200,
          height: 800,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FormulaReferencePanel), findsOneWidget);
    });

    testWidgets('FormulaReferencePanel ka 3 karta formulash', (tester) async {
      tester.view.physicalSize = const Size(1200 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          GeometryChallengeScreen(random: Random(42)),
          width: 1200,
          height: 800,
        ),
      );
      await tester.pumpAndSettle();

      // 3 formula të shfaqura
      expect(find.text('S = g × l'), findsOneWidget);
      expect(find.text('S = (b × h) ÷ 2'), findsOneWidget);
      expect(find.text('P = b × 4'), findsOneWidget);
    });
  });
}
