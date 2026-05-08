// D2: Widget tests për AdaptiveScaffold
// Verifikojmë se AdaptiveScaffold selekton navigimin e duhur sipas gjerësisë.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/l10n/app_localizations.dart';
import 'package:math_lingo/shared/navigation/adaptive_scaffold.dart';
import 'package:math_lingo/shared/widgets/cosmic_bottom_nav.dart';
import 'package:math_lingo/shared/utils/user_progress_storage.dart';

/// Ndërton test app me MediaQuery të caktuar.
Widget buildScaffoldTestApp(Widget home, {double width = 400}) {
  return ProviderScope(
    child: MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
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

/// Widget i thjeshtë për testim — body placeholder.
Widget get _placeholder => const ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(),
    );

AdaptiveScaffold _makeScaffold({required double width}) {
  return AdaptiveScaffold(
    selectedIndex: 0,
    onSelected: (_) {},
    body: _placeholder,
  );
}

void main() {
  late Directory hiveTestDirectory;

  setUpAll(() async {
    hiveTestDirectory = await Directory.systemTemp.createTemp(
      'adaptive_scaffold_hive_test_',
    );
    await UserProgressStorage.resetForTests(testPath: hiveTestDirectory.path);
  });

  group('AdaptiveScaffold — <600px (mobile)', () {
    testWidgets('shfaq CosmicBottomNav', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 800 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildScaffoldTestApp(_makeScaffold(width: 375), width: 375),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CosmicBottomNav), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('nuk shfaq NavigationRail', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 800 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildScaffoldTestApp(_makeScaffold(width: 375), width: 375),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsNothing);
    });
  });

  group('AdaptiveScaffold — ≥600px (tablet me etiketa)', () {
    testWidgets('shfaq NavigationRail', (tester) async {
      tester.view.physicalSize = const Size(700 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildScaffoldTestApp(_makeScaffold(width: 700), width: 700),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
    });

    testWidgets('nuk shfaq CosmicBottomNav', (tester) async {
      tester.view.physicalSize = const Size(700 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildScaffoldTestApp(_makeScaffold(width: 700), width: 700),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CosmicBottomNav), findsNothing);
    });

    testWidgets('NavigationRail është gjithmonë extended (etiketa të dukshme)', (tester) async {
      tester.view.physicalSize = const Size(700 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildScaffoldTestApp(_makeScaffold(width: 700), width: 700),
      );
      await tester.pumpAndSettle();

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      // Rail gjithmonë extended ≥600px — fëmijët kanë nevojë për etiketa.
      expect(rail.extended, isTrue);
    });
  });

  group('AdaptiveScaffold — ≥840px (desktop extended)', () {
    testWidgets('shfaq NavigationRail', (tester) async {
      tester.view.physicalSize = const Size(1024 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildScaffoldTestApp(_makeScaffold(width: 1024), width: 1024),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
    });

    testWidgets('NavigationRail është extended (etiketa të dukshme)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1024 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildScaffoldTestApp(_makeScaffold(width: 1024), width: 1024),
      );
      await tester.pumpAndSettle();

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);
    });

    testWidgets('nuk shfaq CosmicBottomNav', (tester) async {
      tester.view.physicalSize = const Size(1024 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildScaffoldTestApp(_makeScaffold(width: 1024), width: 1024),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CosmicBottomNav), findsNothing);
    });
  });
}
