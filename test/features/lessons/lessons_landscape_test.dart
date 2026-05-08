// D1: Widget tests për LessonsPage landscape layout
// Teston se ExamplesPanel shfaqet në landscape dhe fshihet në portrait.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/features/dashboard/presentation/lessons_page.dart';
import 'package:math_lingo/features/lessons/widgets/examples_panel.dart';
import 'package:math_lingo/l10n/app_localizations.dart';

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
        home: Scaffold(
          body: home,
        ),
      ),
    ),
  );
}

void main() {
  group('LessonsPage — portrait (800×1200)', () {
    testWidgets('nuk shfaq ExamplesPanel në portrait', (tester) async {
      tester.view.physicalSize = const Size(800 * 2, 1200 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          LessonsPage(onStartGeometryChallenge: () {}),
          width: 800,
          height: 1200,
        ),
      );
      await tester.pump(); await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(ExamplesPanel), findsNothing);
    });
  });

  group('LessonsPage — landscape (1200×800)', () {
    testWidgets('shfaq ExamplesPanel në landscape', (tester) async {
      tester.view.physicalSize = const Size(1200 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          LessonsPage(onStartGeometryChallenge: () {}),
          width: 1200,
          height: 800,
        ),
      );
      await tester.pump(); await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(ExamplesPanel), findsOneWidget);
    });

    testWidgets('shfaq 6 shembuj ekuacionesh', (tester) async {
      tester.view.physicalSize = const Size(1200 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          LessonsPage(onStartGeometryChallenge: () {}),
          width: 1200,
          height: 800,
        ),
      );
      await tester.pump(); await tester.pump(const Duration(milliseconds: 500));

      // ExamplesPanel ka 6 _ExampleCard items
      expect(find.text('3 + 4 = 7'), findsOneWidget);
      expect(find.text('12 ÷ 4 = 3'), findsOneWidget);
    });

    testWidgets('ekuacioni është gjithmonë i dukshëm (jo i mbulosur)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          LessonsPage(onStartGeometryChallenge: () {}),
          width: 1200,
          height: 800,
        ),
      );
      await tester.pump(); await tester.pump(const Duration(milliseconds: 500));

      // '5 + 3 = 8' ekuacioni duhet të jetë i dukshëm (B3 fix)
      expect(find.text('5 + 3 = 8'), findsOneWidget);
    });
  });
}
