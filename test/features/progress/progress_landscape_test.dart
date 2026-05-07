// D1: Widget tests per layout-et landscape te Sprint 5
// Teston se kolona e djathte shfaqet ne landscape dhe fshihet ne portrait.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/features/dashboard/presentation/progress_page.dart';
import 'package:math_lingo/features/progress/widgets/module_progress_ring.dart';
import 'package:math_lingo/features/progress/widgets/session_history_panel.dart';
import 'package:math_lingo/l10n/app_localizations.dart';
import 'package:math_lingo/shared/utils/user_progress_storage.dart';

Widget buildTestApp(Widget home, {required double width, required double height}) {
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
        home: Scaffold(body: home),
      ),
    ),
  );
}

Future<void> pumpUntilLoaded(WidgetTester tester) async {
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  late Directory hiveTestDir;

  setUpAll(() async {
    hiveTestDir = await Directory.systemTemp.createTemp('progress_landscape_test_');
    await UserProgressStorage.resetForTests(testPath: hiveTestDir.path);
  });

  tearDownAll(() async {
    try {
      await hiveTestDir.delete(recursive: true);
    } catch (_) {}
  });

  group('ProgressPage portrait 800x1200', () {
    testWidgets('nuk shfaq SessionHistoryPanel', (tester) async {
      tester.view.physicalSize = const Size(800 * 2, 1200 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(const ProgressPage(), width: 800, height: 1200),
      );
      await pumpUntilLoaded(tester);

      expect(find.byType(SessionHistoryPanel), findsNothing);
    });
  });

  group('ProgressPage landscape 1200x800', () {
    testWidgets('shfaq SessionHistoryPanel ne landscape', (tester) async {
      tester.view.physicalSize = const Size(1200 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(const ProgressPage(), width: 1200, height: 800),
      );
      await pumpUntilLoaded(tester);

      expect(find.byType(SessionHistoryPanel), findsOneWidget);
    });

    testWidgets('shfaq ModuleProgressRing ne landscape', (tester) async {
      tester.view.physicalSize = const Size(1200 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(const ProgressPage(), width: 1200, height: 800),
      );
      await pumpUntilLoaded(tester);

      expect(find.byType(ModuleProgressRing), findsOneWidget);
    });
  });
}
